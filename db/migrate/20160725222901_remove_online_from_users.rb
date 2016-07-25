class RemoveOnlineFromUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :online, :boolean
  end
end
