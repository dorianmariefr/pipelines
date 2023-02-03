class ChangeErrorAndBacktrace < ActiveRecord::Migration[7.0]
  def change
    remove_column :sources, :error
    remove_column :destinations, :error
    add_column :pipelines, :error, :text
  end
end
