class AddGameStartedToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :game_started, :boolean, default: false
  end
end
