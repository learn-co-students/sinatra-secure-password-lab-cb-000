class AddBalance < ActiveRecord::Migration
  def change
    add_column :users, :balance, :decimal, :default => 0.0
  end
end
