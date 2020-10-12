class CreateWeathers < ActiveRecord::Migration[6.0]
  def change
    create_table :weathers do |t|
      t.string :checksum
      t.text :m_data
      t.datetime :refresh_time, null: false
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :weathers, :deleted_at
  end
end
