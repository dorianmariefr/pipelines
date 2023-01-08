class SendToDestinationJob < ApplicationJob
  queue_as :default

  def perform(destination:, item:)
    destination.send_now(item)
  end
end
