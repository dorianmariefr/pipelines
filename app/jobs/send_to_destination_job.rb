class SendToDestinationJob < ApplicationJob
  queue_as :default

  def perform(destination:, item: nil, items: nil) # TODO: remove item
    destination.send_now(items)
  end
end
