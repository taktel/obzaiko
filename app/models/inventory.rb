class Inventory < ApplicationRecord
  after_save :calc_daily_usage
  
  belongs_to :user
  belongs_to :item
  
  validates :type, presence: true
  validates :date, presence: true
  validates :number, presence: true
  validates :user_id, presence: true
  validates :item_id, presence: true
  
  private
  
  def calc_daily_usage
    unless inventories = self.item.inventories.where(date: (Date.today-365)..Date.today) #過去1年間をもとに計算
      first_day = inventories.order(:date).first.date #データベースの最初の日
      integrated_add = 0.0 #積算入荷数
      number_plus = [] #[最初の日起算の日数, 在庫数に積算入荷数を加えた数]
      inventories.order(date: "DESC").each do |inventory|
        if inventory.type == "Check"
          number_plus.push( [ (inventory.date - first_day).to_f, (inventory.number + integrated_add).to_f ] )
        elsif inventory.type == "Add"
          integrated_add += inventory.number
        end
      end
      # 最小二乗近似で傾きを計算
      b = c = d = e = 0.0
      number_plus.each do |x, y|
        b += x**2
        c += y
        d += x*y
        e += x
      end
      n = number_plus.size.to_f
      self.item.daily_usage = -1.0*(n*d-c*e)/(n*b-e**2)
      if self.item.daily_usage > 0
        self.item.save
      end
    end
  end
end
