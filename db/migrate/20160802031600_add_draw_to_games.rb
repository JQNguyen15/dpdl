class AddDrawToGames < ActiveRecord::Migration[5.0]
  def change
    add_column :games, :draw_votes, :integer, default: 0
  end
end
