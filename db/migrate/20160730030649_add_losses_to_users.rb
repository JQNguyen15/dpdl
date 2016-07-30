class AddLossesToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :losses, :integer, :default => 0
  end
end
