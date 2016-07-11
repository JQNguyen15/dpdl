class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :winner
      t.string :players

      t.timestamps null: false
    end
  end
end
