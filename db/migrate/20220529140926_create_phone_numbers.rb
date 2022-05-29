class CreatePhoneNumbers < ActiveRecord::Migration[7.0]
  def change
    create_table :phone_numbers do |t|
      t.references :user, null: false, foreign_key: true
      t.string :phone_number, null: false
      t.boolean :verified, null: false, default: false
      t.string :verification_code

      t.timestamps

      t.index :phone_number, unique: true
      t.index :verification_code, unique: true
    end
  end
end
