class ChangeParametersValueToText < ActiveRecord::Migration[7.0]
  def change
    change_column :parameters, :value, :text
  end
end
