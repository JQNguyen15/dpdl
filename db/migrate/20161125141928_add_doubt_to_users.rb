class AddDoubtToUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :doubt, :float
  end
  def change
    add_column :users, :doubt, :float, :default => 8.333333333333334
  end
end
