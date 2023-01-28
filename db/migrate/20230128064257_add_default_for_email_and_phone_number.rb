class AddDefaultForEmailAndPhoneNumber < ActiveRecord::Migration[7.0]
  def change
    change_column_default :emails, :email, ""
    change_column_default :phone_numbers, :phone_number, ""
  end
end
