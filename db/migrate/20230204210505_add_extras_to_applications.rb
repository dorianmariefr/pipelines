class AddExtrasToApplications < ActiveRecord::Migration[7.0]
  def change
    add_column :applications, :extras, :jsonb, default: {}, null: false
  end
end
