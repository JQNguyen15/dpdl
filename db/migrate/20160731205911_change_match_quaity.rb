class ChangeMatchQuaity < ActiveRecord::Migration[5.0]
  def change
    change_column :games, :match_quality, :float, default: 0.0
  end
end
