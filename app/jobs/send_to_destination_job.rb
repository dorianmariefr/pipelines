class SendToDestinationJob < ApplicationJob
  queue_as :default

  def perform(destination:, items:)
    destination.send_now(items)
  end
end
