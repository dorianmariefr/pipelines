class ProcessPipelinesJob < CronJob
  self.cron_expression = "* * * * *"

  queue_as :default

  def perform
    Pipeline.find_each do |pipeline|
      ProcessPipelineJob.perform_later(pipeline: pipeline)
    end
  end
end
