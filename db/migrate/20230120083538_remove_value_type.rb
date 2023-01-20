class RemoveValueType < ActiveRecord::Migration[7.0]
  def change
    remove_column :sources, :value_type
  end
end
