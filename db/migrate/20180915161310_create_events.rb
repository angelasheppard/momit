class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.string :name
      t.text :description
      t.datetime :start_time
      t.datetime :end_time
      t.string :event_type
      t.boolean :is_template
      t.boolean :is_locked
      t.integer :max_tank
      t.integer :max_dps
      t.integer :max_healer
      t.string :log_url
      t.references :user_creator, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
