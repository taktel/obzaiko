class Order < ApplicationRecord
  belongs_to :item
  belongs_to :order_sheet
  
  has_one :add
  
  validates :number, presence: true, numericality: { greater_than: 0 }
  validates :item_id, presence: true
  
  def self.status_attributes
    {"注文済" => "ordered",
     "入荷済" => "done"   }
  end

  def show_status
    Order.status_attributes.key(self.status)
  end

end
