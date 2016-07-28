class RemoveStufzfFromGames < ActiveRecord::Migration[5.0]
  def change
    remove_column :games, :players, :integer
  end
end
