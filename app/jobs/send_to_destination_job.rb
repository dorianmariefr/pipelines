class SendToDestinationJob < ApplicationJob
  queue_as :default

  retry_on Timeout::Error

  def perform(destination:, items:)
    destination.send_now(items)
  end
end
