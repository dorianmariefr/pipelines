class ChangeItems < ActiveRecord::Migration[7.0]
  def change
    remove_column :items, :subject
    remove_column :items, :body
    add_column :items, :extras, :jsonb, default: {}, null: false
  end
end
