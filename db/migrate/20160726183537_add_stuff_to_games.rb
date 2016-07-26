class AddStuffToGames < ActiveRecord::Migration[5.0]
  def change
    add_column :games, :players, :string
    add_column :games, :winner, :string
    add_column :games, :rad_votes, :integer, default: 0
    add_column :games, :dire_votes, :integer, default: 0
    add_column :games, :aborted, :boolean, default: false
  end
end
