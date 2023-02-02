class ChangeDefaultOperatorAgain < ActiveRecord::Migration[7.0]
  def change
    change_column_default :sources, :operator, :includes
  end
end
