class AddProToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :pro, :boolean, default: false, null: false
  end
end
