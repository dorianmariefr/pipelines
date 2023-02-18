class AddSpamToItem < ActiveRecord::Migration[7.0]
  def change
    add_column :items, :spam, :boolean
  end
end
