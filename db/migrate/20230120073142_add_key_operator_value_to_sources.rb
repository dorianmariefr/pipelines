class AddKeyOperatorValueToSources < ActiveRecord::Migration[7.0]
  def change
    add_column :sources, :key, :string
    add_column :sources, :operator, :string
    add_column :sources, :value, :string
    add_column :sources, :value_type, :string
  end
end
