class AddSkillToUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :skill, :float
  end
  def change
    add_column :users, :skill, :float, :default => 25.0
  end
end
