class EventsRenameCreatorAddTableConstraints < ActiveRecord::Migration[5.2]
  def change
    change_table :events do |t|
      t.rename :user_creator_id, :creator_id
      t.index [:name, :start_time], unique: true

      reversible do |dir|
        dir.up do
          t.change :creator_id, :integer, null: false
          t.change :name, :string, null: false, limit: 100
          t.change :start_time, :datetime, null: false
          t.change :end_time, :datetime, null: false
        end
        dir.down do
          t.change :user_creator_id, :integer, null: true
          t.change :name, :string, null: true
          t.change :start_time, :datetime, null: true
          t.change :end_time, :datetime, null: true
        end
      end
    end
  end
end
