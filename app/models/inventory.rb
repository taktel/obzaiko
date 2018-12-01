class Inventory < ApplicationRecord
  belongs_to :user
  belongs_to :item
  
  validates :type, presence: true
  validates :date, presence: true
  validates :number, presence: true
  validates :item_id, presence: true
end
