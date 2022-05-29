class AddNormalizedEmailAndPhoneNumber < ActiveRecord::Migration[7.0]
  def change
    add_column :emails, :normalized_email, :string
    add_column :phone_numbers, :normalized_phone_number, :string
  end
end
