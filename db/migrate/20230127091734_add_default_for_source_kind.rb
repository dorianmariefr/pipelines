class AddDefaultForSourceKind < ActiveRecord::Migration[7.0]
  def change
    change_column_default :sources, :kind, "twitter/search"
  end
end
