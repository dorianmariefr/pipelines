class AddFilterTypeToSources < ActiveRecord::Migration[7.0]
  def change
    add_column :sources, :filter_type, :string, default: "simple", null: false
  end
end
