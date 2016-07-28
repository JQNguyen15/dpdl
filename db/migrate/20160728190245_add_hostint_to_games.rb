class AddHostintToGames < ActiveRecord::Migration[5.0]
  def change
    add_column :games, :host, :integer
  end
end
