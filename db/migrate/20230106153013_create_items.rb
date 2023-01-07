class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.references :source, null: false, foreign_key: true
      t.string :subject
      t.text :body
      t.string :external_id, null: false

      t.timestamps

      t.index %i[source_id external_id], unique: true
    end
  end
end
