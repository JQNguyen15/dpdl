class AddMatchqualToGames < ActiveRecord::Migration[5.0]
  def change
    add_column :games, :match_quality, :integer, :default => 0
  end
end
