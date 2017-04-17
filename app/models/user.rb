class User < ActiveRecord::Base
  validates :username, presence: true
  validates :balance, 
    numericality: { greater_than_or_equal_to: 0.00 }
  has_secure_password
end
