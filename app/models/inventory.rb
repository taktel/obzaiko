class Inventory < ApplicationRecord
  after_save :calc_monthly_usage
  
  belongs_to :user
  belongs_to :item
  
  validates :type, presence: true
  validates :date, presence: true
  validates :number, presence: true
  validates :item_id, presence: true
  
  private
  
  def calc_monthly_usage
    item = Item.find(self.item_id)
    first_day = item.inventories.order(:date).first.date #データベースの最初の日
    integrated_add = 0.0 #積算入荷数
    number_plus = [] #[最初の日起算の日数, 在庫数に積算入荷数を加えた数]
    item.inventories.order(date: "DESC").each do |inventory|
      if inventory.type == "Check"
        number_plus.push( [ (inventory.date - first_day).to_f, (inventory.number + integrated_add).to_f ] )
      elsif inventory.type == "Add"
        integrated_add += inventory.number
      end
    end
    b = c = d = e = 0.0
    number_plus.each do |x, y|
      b += x**2
      c += y
      d += x*y
      e += x
    end
    n = number_plus.size.to_f
    item.monthly_usage = -365.0/12.0*(n*d-c*e)/(n*b-e**2)
    if item.monthly_usage > 0
      item.save
    end
  end
end
