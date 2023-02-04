Rails.application.config.middleware.use OmniAuth::Builder do
  if Rails.application.credentials.google
    provider(
      :google_oauth2,
      Rails.application.credentials.google.client_id,
      Rails.application.credentials.google.client_secret,
      name: :google
    )
  end

  if Rails.application.credentials.facebook
    provider(
      :facebook,
      Rails.application.credentials.facebook.app_id,
      Rails.application.credentials.facebook.app_secret
    )
  end
end
