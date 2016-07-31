class ChangeGames < ActiveRecord::Migration[5.0]
  def change
    change_column :games, :match_quality, :integer, default: 0
  end
end
