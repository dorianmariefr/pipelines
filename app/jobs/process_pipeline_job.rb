class ProcessPipelineJob < ApplicationJob
  queue_as :default

  def perform(pipeline:)
    pipeline.process_later
  end
end
