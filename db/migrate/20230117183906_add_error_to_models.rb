class AddErrorToModels < ActiveRecord::Migration[7.0]
  def change
    add_column :pipelines, :error, :text
    add_column :sources, :error, :text
    add_column :destinations, :error, :text
  end
end
