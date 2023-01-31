class DeleteAllItems < ActiveRecord::Migration[7.0]
  def change
    Item.destroy_all
  end
end
