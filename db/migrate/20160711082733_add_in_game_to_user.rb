class AddInGameToUser < ActiveRecord::Migration
  def change
    add_column :users, :in_game, :boolean, :default => false
  end
end
