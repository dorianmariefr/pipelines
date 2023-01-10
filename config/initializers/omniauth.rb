Rails.application.config.middleware.use OmniAuth::Builder do
  provider(
    :google_oauth2,
    Rails.application.credentials.google[:client_id],
    Rails.application.credentials.google[:client_secret],
    name: :google
  )

  provider(
    :facebook,
    Rails.application.credentials.facebook[:app_id],
    Rails.application.credentials.facebook[:app_secret]
  )
end
