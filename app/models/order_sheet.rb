class OrderSheet < ApplicationRecord
  belongs_to :user
  belongs_to :vendor
  has_many :orders, dependent: :destroy

  validates :vendor_id, presence: true
  
  accepts_nested_attributes_for :orders, allow_destroy: true
  
  def status_done?
    self.orders.map{ |order| order[:status] }.all?{ |status| status == "done" }
  end
end
