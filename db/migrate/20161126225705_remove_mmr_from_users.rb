class RemoveMmrFromUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :mmr
  end
end
