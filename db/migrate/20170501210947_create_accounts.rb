class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.decimal :balance, default: 0
      t.belongs_to :user
    end
  end
end
