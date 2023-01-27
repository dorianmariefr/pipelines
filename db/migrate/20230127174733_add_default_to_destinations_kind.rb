class AddDefaultToDestinationsKind < ActiveRecord::Migration[7.0]
  def change
    change_column_default :destinations, :kind, "email"
  end
end
