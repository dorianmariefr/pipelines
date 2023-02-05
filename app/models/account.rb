class Account < ApplicationRecord
  # e.g. @dorianmariefr@ruby.social
  MASTODON_IDENTIFIER_REGEXP =
    /\A@?\b([a-zA-Z0-9._%+-]+)@([a-zA-Z0-9.-]+\.[a-zA-Z]{2,})\z/
  MASTODON = "mastodon"

  SCOPES = ["read", "read write"]

  KINDS = [MASTODON]

  belongs_to :user

  scope :mastodon, -> { where(kind: MASTODON) }

  validates :kind, inclusion: {in: KINDS}
  validates :external_id, presence: true
  validates :scope, inclusion: {in: SCOPES}

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
