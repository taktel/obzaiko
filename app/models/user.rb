class User < ApplicationRecord
  validates :name, presence: true, length: { maximum: 50}
  
  has_secure_password
  
  has_many :inventories
  has_many :adds
  has_many :checks
  has_many :order_sheets
  
  def authority_admin?
    self.level == "Administrator"
  end
  
  def authority_order?
    ["Administrator", "Manager"].include?(self.level)
  end
  
end
