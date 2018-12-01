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
  
  private
  
  def calc_monthly_usage
    first_day = self.inventories.order(:date).first.date #データベースの最初の日
    integrated_add = 0 #積算入荷数
    number_plus = [] #[最初の日起算の日数, 在庫数に積算入荷数を加えた数]
    first_day = self.inventories.order(:date).first.date
    self.inventories.reverse_order(:date).each do |inventory|
      if inventory.type = "Check"
        number_plus.push( [ (inventory.date - first_day).to_f, inventory.number+integrated_add ] )
      elsif inventory.type = "Add"
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
    n = number_plus.size
    -365/12*(n*d-c*e)/(n*b-e**2)
  end
      
end
