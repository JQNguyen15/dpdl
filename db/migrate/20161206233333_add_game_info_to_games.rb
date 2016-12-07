class AddGameInfoToGames < ActiveRecord::Migration[5.0]
  def change
    add_column :games, :w, :float, :default => 0.0
    add_column :games, :v, :float, :default => 0.0
    add_column :games, :c, :float, :default => 0.0
    add_column :games, :teamASTDSum, :float, :default => 0.0
    add_column :games, :teamBSTDSum, :float, :default => 0.0
    add_column :games, :teamAMeanSum, :float, :default => 0.0
    add_column :games, :teamBMeanSum, :float, :default => 0.0
  end
end
