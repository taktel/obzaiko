class Item < ApplicationRecord
  belongs_to :category
  
  validates :name, presence: true, length: { maximum: 50 }
  validates :code, length: { maximum: 50 }
  validates :unit, presence: true, length: { maximum: 10 }
  validates :storage_location, length: { maximum: 50 }
  validates :vendor, length: { maximum: 50 }
  validates :lead_time, presence: true
  
  has_many :inventories
  has_many :adds
  has_many :checks
end
