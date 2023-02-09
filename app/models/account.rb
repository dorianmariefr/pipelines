class Account < ApplicationRecord
  MASTODON = "mastodon"
  DEFAULT_MASTODON_SCOPES = ["read"]
  MASTODON_SCOPES = %w[read write follow push admin:read admin:write]
  # e.g. @dorianmariefr@ruby.social
  MASTODON_IDENTIFIER_REGEXP =
    /\A@?\b([a-zA-Z0-9._%+-]+)@([a-zA-Z0-9.-]+\.[a-zA-Z]{2,})\z/

  TWITTER = "twitter"
  DEFAULT_TWITTER_SCOPES = %w[tweet.read offline.access]
  TWITTER_SCOPES = %w[
    tweet.read
    tweet.write
    tweet.moderate.write
    users.read
    follows.read
    follows.write
    offline.access
    space.read
    mute.read
    mute.write
    like.read
    like.write
    list.read
    list.write
    block.read
    block.write
    bookmark.read
    bookmark.write
  ]
  # e.g. @dorianmariefr
  TWITTER_IDENTIFIER_REGEXP = /\A@(\w){1,15}\z/

  KINDS = [MASTODON, TWITTER]

  belongs_to :user

  scope :mastodon, -> { where(kind: MASTODON) }
  scope :twitter, -> { where(kind: TWITTER) }

  validates :kind, inclusion: {in: KINDS}
  validates :external_id, presence: true

  def authorized?
    !!access_token
  end

  def access_token
    extras["access_token"]
  end

  def translated_kind
    I18n.t("accounts.model.kinds.#{kind}")
  end

  def mastodon?
    kind == MASTODON
  end

  def twitter?
    kind == TWITTER
  end

  def scope=(scope)
    if scope.is_a?(Array)
      self.scope = scope.join(" ")
    else
      super
    end
  end

  def domain
    if mastodon?
      external_id.split("@").third
    else
      raise NotImplementedError
    end
  end

  def application
    if mastodon?
      Application.find_by(kind: MASTODON, domain: domain)
    elsif twitter?
      nil
    else
      raise NotImplementedError
    end
  end

  def authorize_url
    if mastodon?
      query = {
        client_id: application.client_id,
        redirect_uri:
          Rails.application.routes.url_helpers.mastodon_callback_accounts_url,
        response_type: :code,
        scope: scope
      }.to_query

      "https://#{domain}/oauth/authorize?#{query}"
    else
      raise NotImplementedError
    end
  end

  def application!
    if mastodon?
      application || create_application!
    elsif twitter?
      nil
    else
      raise NotImplementedError
    end
  end

  def create_application!
    if mastodon?
      uri = URI.parse("https://#{domain}/api/v1/apps")
      request = Net::HTTP::Post.new(uri)
      request.body = {
        client_name: Rails.application.credentials.mastodon.client_name,
        redirect_uris:
          Rails.application.routes.url_helpers.mastodon_callback_accounts_url,
        website: Rails.application.routes.url_helpers.root_url,
        scopes: "read write push admin:read admin:write"
      }.to_query

      response =
        Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
          http.request(request)
        end

      json = JSON.parse(response.body, object_class: OpenStruct)

      Application.create!(
        kind: MASTODON,
        domain: domain,
        client_id: json.client_id,
        client_secret: json.client_secret
      )
    elsif twitter?
      nil
    else
      raise NotImplementedError
    end
  end

  def callback(code)
    if mastodon?
      uri = URI.parse("https://#{domain}/oauth/token")
      request = Net::HTTP::Post.new(uri)
      request.body = {
        grant_type: :authorization_code,
        scope: scope,
        redirect_uri:
          Rails.application.routes.url_helpers.mastodon_callback_accounts_url,
        client_id: application.client_id,
        client_secret: application.client_secret,
        code: code
      }.to_query
      response =
        Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
          http.request(request)
        end
      update!(extras: JSON.parse(response.body))
    else
      raise NotImplementedError
    end
  end
end
