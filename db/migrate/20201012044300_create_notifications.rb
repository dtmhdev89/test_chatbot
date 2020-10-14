class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications do |t|
      t.integer :schedule_type, null: false
      t.string :title_name, null: false
      t.integer :creator_id
      t.text :noti_content, null: false
      t.text :scheduled_at
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :notifications, :schedule_type
    add_index :notifications, [:creator_id, :title_name], unique: true
  end
end
