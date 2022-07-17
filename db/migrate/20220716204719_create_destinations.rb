class CreateDestinations < ActiveRecord::Migration[7.0]
  def change
    create_table :destinations do |t|
      t.references :pipeline, null: false, foreign_key: true
      t.string :kind, null: false

      t.timestamps
    end
  end
end
