class AddWinsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :wins, :integer, :default => 0
  end
end
