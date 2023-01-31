class RemoveBacktraces < ActiveRecord::Migration[7.0]
  def change
    remove_column :sources, :backtrace
    remove_column :destinations, :backtrace
  end
end
