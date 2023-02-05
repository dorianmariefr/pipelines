class CreateApplications < ActiveRecord::Migration[7.0]
  def change
    create_table :applications do |t|
      t.string :kind, null: false, default: :mastodon
      t.string :domain, null: false
      t.string :client_id, null: false
      t.string :client_secret, null: false

      t.timestamps
    end
  end
end
