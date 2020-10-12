class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.integer :type, null: false, default: 0
      t.string :ref_email, null: false
      t.integer :chat_type, null: false, default: 0
      t.string :ref_chat_account, null: false
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :users, [:chat_type, :ref_email, :ref_account], unique: true
  end
end
