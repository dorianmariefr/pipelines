class Account < ApplicationRecord
  MASTODON = "mastodon"
  DEFAULT_MASTODON_SCOPES = ["read"]
  MASTODON_SCOPES = %w[read write follow push admin:read admin:write]
  # e.g. @dorianmariefr@ruby.social
  MASTODON_IDENTIFIER_REGEXP =
    /\A@?\b([a-zA-Z0-9._%+-]+)@([a-zA-Z0-9.-]+\.[a-zA-Z]{2,})\z/

  TWITTER = "twitter"
  DEFAULT_TWITTER_SCOPES = %w[read]
  TWITTER_SCOPES = %w[read write]
  # e.g. @dorianmariefr
  TWITTER_IDENTIFIER_REGEXP = /\A@(\w){1,15}\z/
  TWITTER_DOMAIN = "twitter.com"
  PROTOCOL = "https"

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
    elsif twitter?
      TWITTER_DOMAIN
    else
      raise NotImplementedError
    end
  end

  def domain_with_protocol
    "#{PROTOCOL}://#{domain}"
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

  def redirect_uri
    if mastodon?
      Rails.application.routes.url_helpers.mastodon_callback_accounts_url
    elsif twitter?
      Rails.application.routes.url_helpers.twitter_callback_accounts_url
    else
      raise NotImplementedError
    end
  end

  def root_url
    Rails.application.routes.url_helpers.root_url
  end

  def credentials
    if mastodon?
      Rails.application.credentials.mastodon
    elsif twitter?
      Rails.application.credentials.twitter
    else
      raise NotImplementedError
    end
  end

  def consumer
    if twitter?
      @consumer ||=
        OAuth::Consumer.new(
          credentials.api_key,
          credentials.api_key_secret,
          site: domain_with_protocol
        )
    else
      raise NotImplementedError
    end
  end

  def authorize_url
    if mastodon?
      query = {
        client_id: application.client_id,
        redirect_uri: redirect_uri,
        response_type: :code,
        scope: scope
      }.to_query

      "https://#{domain}/oauth/authorize?#{query}"
    elsif twitter?
      request_token =
        consumer.get_request_token(
          {oauth_callback: redirect_uri},
          x_auth_access_type: scope
        )
      update!(
        extras: {
          token: request_token.token,
          secret: request_token.secret
        }
      )
      request_token.authenticate_url
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
      uri = URI.parse("#{domain_with_protocol}/api/v1/apps")
      request = Net::HTTP::Post.new(uri)
      request.body = {
        client_name: credentials.mastodon.client_name,
        redirect_uris: redirect_uri,
        website: root_url,
        scopes: MASTODON_SCOPES.join(" ")
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
      uri = URI.parse("#{domain_with_protocol}/oauth/token")
      request = Net::HTTP::Post.new(uri)
      request.body = {
        grant_type: :authorization_code,
        scope: scope,
        redirect_uri: redirect_uri,
        client_id: application.client_id,
        client_secret: application.client_secret,
        code: code
      }.to_query

      response =
        Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
          http.request(request)
        end

      update!(extras: JSON.parse(response.body))
    elsif twitter?
      request_token =
        OAuth::RequestToken.from_hash(
          consumer,
          oauth_token: extras["token"],
          oauth_token_secret: extras["secret"]
        )
      access_token = request_token.get_access_token(oauth_verifier: code)
      update!(external_id: "@#{access_token.params[:screen_name]}")
      update!(
        extras: {
          access_token: access_token.token,
          access_token_secret: access_token.secret
        }
      )
    else
      raise NotImplementedError
    end
  end
end
