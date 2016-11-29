class AddAvgMmrToGames < ActiveRecord::Migration[5.0]
  def change
    add_column :games, :radiMmr, :integer, :default => 0.0
    add_column :games, :direMmr, :integer, :default => 0.0
  end
end
