class CreateEmails < ActiveRecord::Migration[7.0]
  def change
    create_table :emails do |t|
      t.references :user, null: false, foreign_key: true
      t.string :email, null: false
      t.boolean :verified, null: false, default: false
      t.string :verification_code

      t.timestamps

      t.index :email, unique: true
      t.index :verification_code, unique: true
    end
  end
end
