class ChangeDefaultDestinationKind < ActiveRecord::Migration[7.0]
  def change
    change_column_default :destinations, :kind, "daily_email_digest"
  end
end
