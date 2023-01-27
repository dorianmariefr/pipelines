class AddTransformToSources < ActiveRecord::Migration[7.0]
  def change
    add_column :sources, :transform, :string, default: "none", null: false
  end
end
