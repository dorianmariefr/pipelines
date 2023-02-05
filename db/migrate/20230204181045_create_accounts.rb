class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts do |t|
      t.string :kind, null: false, default: :mastodon
      t.references :user, null: false, foreign_key: true
      t.string :external_id, null: false
      t.jsonb :extras, null: false, default: {}

      t.timestamps
    end
  end
end
