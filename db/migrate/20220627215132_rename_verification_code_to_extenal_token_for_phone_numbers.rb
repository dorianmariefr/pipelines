class RenameVerificationCodeToExtenalTokenForPhoneNumbers < ActiveRecord::Migration[
  7.0
]
  def change
    remove_column :phone_numbers, :verification_code
    add_column :phone_numbers, :external_token, :string
  end
end
