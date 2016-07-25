class RemoveStuffFromGames < ActiveRecord::Migration[5.0]
  def change
    remove_column :games, :host, :string
    remove_column :games, :winner, :string
    remove_column :games, :players, :string
  end
end
