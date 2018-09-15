class CreateAttendees < ActiveRecord::Migration[5.2]
  def change
    create_table :attendees do |t|
      t.boolean :is_slotted
      t.boolean :is_available
      t.boolean :is_not_available
      t.boolean :as_tank
      t.boolean :as_dps
      t.boolean :as_healer
      t.boolean :did_attend
      t.text :signup_note
      t.text :grouplead_note
      t.references :event, foreign_key: true
      t.references :character, foreign_key: true

      t.timestamps
    end
  end
end
