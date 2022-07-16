class AddSlugToPipelines < ActiveRecord::Migration[7.0]
  def change
    add_column :pipelines, :slug, :string, null: false
    add_index :pipelines, :slug, unique: true
  end
end
