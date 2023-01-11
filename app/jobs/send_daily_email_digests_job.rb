class SendDailyEmailDigestsJob < CronJob
  self.cron_expression = "0 * * * *"

  queue_as :default

  def perform
    Destination.daily_email_digest.find_each do |destination|
      if destination.user.hour == destination.params[:hour].to_i
        destination.send_later
      end
    end
  end
end
