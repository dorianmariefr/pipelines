class PrimaryEmailAndPhoneNumberForUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :email

    add_reference(
      :users,
      :primary_email,
      foreign_key: {
        to_table: :emails
      },
      index: {
        unique: true
      }
    )

    add_reference(
      :users,
      :primary_phone_number,
      foreign_key: {
        to_table: :phone_numbers
      },
      index: {
        unique: true
      }
    )
  end
end
