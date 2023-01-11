class SendMonthlyEmailDigestsJob < CronJob
  self.cron_expression = "0 * * * *"

  queue_as :default

  def perform
    Destination.monthly_email_digest.find_each do |destination|
      user = destination.user

      if user.hour == destination.params[:hour].to_i &&
           user.day_of_month == destination.params[:day_of_month].to_i
        destination.send_later
      end
    end
  end
end
