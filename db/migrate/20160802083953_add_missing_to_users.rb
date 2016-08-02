class AddMissingToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :skill, :float, default: 25.0
    add_column :users, :doubt, :float, default: 8.333
  end
end
