class AddDrawsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :draws, :integer, :default => 0
  end
end
