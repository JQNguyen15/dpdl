class ChangeAvgMmrToFloat < ActiveRecord::Migration[5.0]
  def change
    change_column :games, :radiMmr, :decimal
    change_column :games, :direMmr, :decimal
  end
end
