class AddBacktraceToPipelines < ActiveRecord::Migration[7.0]
  def change
    add_column :pipelines, :backtrace, :text
  end
end
