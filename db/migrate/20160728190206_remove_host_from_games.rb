class RemoveHostFromGames < ActiveRecord::Migration[5.0]
  def change
    remove_column :games, :host, :string
  end
end
