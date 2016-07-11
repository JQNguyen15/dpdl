class AddStartedToGames < ActiveRecord::Migration
  def change
    add_column :games, :started, :boolean, :default => false
  end
end
