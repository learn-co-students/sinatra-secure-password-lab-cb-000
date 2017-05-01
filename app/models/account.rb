class Account < ActiveRecord::Base
  belongs_to :user

  validate :have_enough_funds
  
  def deposit(amount)
    self.balance = balance.to_f + amount.to_f
  end

  def withdraw(amount)
    @old_balance = balance.to_f
    @withdraw_amount = amount.to_f

    self.balance = @old_balance - @withdraw_amount
  end

  private

  def have_enough_funds
    return unless @withdraw_amount && @old_balance

    if @withdraw_amount > @old_balance
      errors.add(:insufficient_funds, "You don't have enough founds.")
    end
  end
end
