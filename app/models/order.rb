class Order < ApplicationRecord
  belongs_to :item
  belongs_to :order_sheet
end
