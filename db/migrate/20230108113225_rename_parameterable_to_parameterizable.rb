class RenameParameterableToParameterizable < ActiveRecord::Migration[7.0]
  def change
    rename_column :parameters, :parameterable_id, :parameterizable_id
    rename_column :parameters, :parameterable_type, :parameterizable_type
  end
end
