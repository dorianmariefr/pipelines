class AddBacktraceToModels < ActiveRecord::Migration[7.0]
  def change
    add_column :pipelines, :backtrace, :text
    add_column :sources, :backtrace, :text
    add_column :destinations, :backtrace, :text
  end
end
