class CreateMovies < ActiveRecord::Migration[6.0]
  def change
    create_table :movies do |t|
      t.string :checksum
      t.datetime :refresh_time, null: false
      t.text :m_data
      t.datetime :deleted_at, index: true

      t.timestamps
    end
  end
end
