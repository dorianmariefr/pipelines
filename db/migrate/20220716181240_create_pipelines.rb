class CreatePipelines < ActiveRecord::Migration[7.0]
  def change
    create_table :pipelines do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false, default: ""
      t.boolean :published, null: false, default: false

      t.timestamps
    end
  end
end
