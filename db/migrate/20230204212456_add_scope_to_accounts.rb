class AddScopeToAccounts < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts, :scope, :string, default: :read, null: false
  end
end
