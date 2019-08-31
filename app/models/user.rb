class User < ActiveRecord::Base
  has_secure_password
  validates_presence_of :username, :password, :on => :create

  def add_deposit(deposit)
    self.balance += BigDecimal(deposit)
    self.update(balance: self.balance)
  end

  def make_withdrawal(withdrawal)
      self.balance -= BigDecimal(withdrawal)
      self.update(balance: self.balance)
  end

  def withdrawal_valid?(withdrawal)
    self.balance > BigDecimal(withdrawal)
  end
end
