class AddExpectationsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :expectations, :string
  end
end
