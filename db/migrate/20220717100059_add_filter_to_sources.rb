class AddFilterToSources < ActiveRecord::Migration[7.0]
  def change
    add_column :sources, :filter, :string, null: false, default: ""
  end
end
