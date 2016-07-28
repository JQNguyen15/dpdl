class AddStu2ffToGames < ActiveRecord::Migration[5.0]
  def change
    add_column :games, :players, :integer, array: true, default: []
  end
end
