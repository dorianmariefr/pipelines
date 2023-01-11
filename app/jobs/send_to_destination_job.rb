class SendToDestinationJob < ApplicationJob
  queue_as :default

  def perform(destination:, item:, items: nil) # TODO: remove item
    destination.send_now(items)
  end
end
