class DeleteTwitterItems < ActiveRecord::Migration[7.0]
  def change
    Item.twitter.destroy_all
  end
end
