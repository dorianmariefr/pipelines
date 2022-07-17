class CreateParameters < ActiveRecord::Migration[7.0]
  def change
    create_table :parameters do |t|
      t.references :parameterable, polymorphic: true, null: false
      t.string :key, null: false
      t.string :value, null: false

      t.timestamps
    end
  end
end
