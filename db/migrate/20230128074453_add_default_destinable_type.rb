class AddDefaultDestinableType < ActiveRecord::Migration[7.0]
  def change
    change_column_default :destinations, :destinable_type, "Email"
  end
end
