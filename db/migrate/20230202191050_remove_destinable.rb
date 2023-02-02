class RemoveDestinable < ActiveRecord::Migration[7.0]
  def change
    remove_reference :destinations, :destinable, polymorphic: true
  end
end
