class RemovePlayersFromGames < ActiveRecord::Migration[5.0]
  def change
    remove_column :games, :players, :string
  end
end
