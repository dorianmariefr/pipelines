class AddDefaultNameForUsers < ActiveRecord::Migration[7.0]
  def change
    change_column_default :users, :name, ""
  end
end
