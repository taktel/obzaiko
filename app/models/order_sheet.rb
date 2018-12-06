class OrderSheet < ApplicationRecord
  belongs_to :user
  belogns_to :vendor
  
  has_many :orders, dependent: :destroy
end
