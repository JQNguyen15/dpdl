class AddRadiantDireToGames < ActiveRecord::Migration[5.0]
  def change
    add_column :games, :radint, :integer, array: true, default: []
    add_column :games, :dire, :integer, array: true, default: []
  end
end
