class AddDestinableToDestinations < ActiveRecord::Migration[7.0]
  def change
    add_reference :destinations, :destinable, polymorphic: true, null: false
  end
end
