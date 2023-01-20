class ChangeFilterTypeDefault < ActiveRecord::Migration[7.0]
  def change
    change_column_default :sources, :filter_type, :none
  end
end
