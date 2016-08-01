class AddLosersToGames < ActiveRecord::Migration[5.0]
  def change
    add_column :games, :loser, :string
  end
end
