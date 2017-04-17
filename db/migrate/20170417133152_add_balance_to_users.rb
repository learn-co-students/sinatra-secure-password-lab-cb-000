class AddBalanceToUsers < ActiveRecord::Migration
  def change
    add_column :users, :balance, :float, precision: 2, scale: 2
  end
end
