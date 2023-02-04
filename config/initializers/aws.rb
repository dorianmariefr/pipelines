if Rails.env.production?
  Aws::Rails.add_action_mailer_delivery_method(
    :ses,
    credentials:
      Aws::Credentials.new(
        Rails.application.credentials.aws.access_key_id,
        Rails.application.credentials.aws.secret_access_key
      ),
    region: Rails.application.credentials.aws.region
  )
end
