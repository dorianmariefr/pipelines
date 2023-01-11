class SendHourlyEmailDigestsJob < CronJob
  self.cron_expression = "0 * * * *"

  queue_as :default

  def perform
    Destination.hourly_email_digest.find_each do |destination|
      destination.send_later
    end
  end
end
