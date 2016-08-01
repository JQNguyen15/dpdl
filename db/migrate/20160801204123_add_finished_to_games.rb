class AddFinishedToGames < ActiveRecord::Migration[5.0]
  def change
    add_column :games, :finished, :boolean, default: false
  end
end
