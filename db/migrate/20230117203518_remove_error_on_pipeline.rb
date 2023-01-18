class RemoveErrorOnPipeline < ActiveRecord::Migration[7.0]
  def change
    remove_column :pipelines, :error
    remove_column :pipelines, :backtrace
  end
end
