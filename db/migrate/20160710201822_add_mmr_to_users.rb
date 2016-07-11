class AddMmrToUsers < ActiveRecord::Migration
  def change
    add_column :users, :mmr, :integer, :default => 1000
  end
end
