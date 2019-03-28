class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |column|
      column.string :username
      column.string :password_digest
      column.integer :balance
    end
  end
end
