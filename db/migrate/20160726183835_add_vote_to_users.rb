class AddVoteToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :has_vote, :boolean, default: false
  end
end
