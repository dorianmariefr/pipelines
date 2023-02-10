class ProcessPipelineJob < ApplicationJob
  queue_as :default

  retry_on Timeout::Error

  def perform(pipeline:)
    pipeline.process_later
  end
end
