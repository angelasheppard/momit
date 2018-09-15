class CreateCharacters < ActiveRecord::Migration[5.2]
  def change
    create_table :characters do |t|
      t.string :name
      t.string :charclass
      t.boolean :is_tank
      t.boolean :is_dps
      t.boolean :is_healer
      t.string :main_role
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
