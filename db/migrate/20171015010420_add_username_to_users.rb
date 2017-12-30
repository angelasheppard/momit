class AddUsernameToUsers < ActiveRecord::Migration[5.1]
    def change
        add_column :users, :username, :string, limit: 30, null: false, unique: true
        add_index :users, :username, unique: true
    end
end
