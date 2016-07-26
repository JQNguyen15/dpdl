class AddHostToGame < ActiveRecord::Migration[5.0]
  def change
    add_column :games, :host, :string
  end
end
