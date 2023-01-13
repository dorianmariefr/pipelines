Sidekiq.configure_server do |config|
  config.on(:startup) do
    schedule_file = "config/schedule.yml"
    Sidekiq::Cron::Job.load_from_hash YAML.safe_load_file(schedule_file)
  end
end
