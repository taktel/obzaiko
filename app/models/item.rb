class Item < ApplicationRecord
  require 'csv'
  belongs_to :category
  belongs_to :vendor
  
  validates :name, presence: true, length: { maximum: 50 }
  validates :code, length: { maximum: 50 }
  validates :unit, presence: true, length: { maximum: 10 }
  validates :storage_location, length: { maximum: 50 }
  validates :lead_time, presence: true
  validates :vendor_id, presence: true
  
  has_many :inventories, dependent: :destroy
  has_many :adds, dependent: :destroy
  has_many :checks, dependent: :destroy
  has_many :orders, dependent: :destroy
  
  def monthly_usage #月間の使用量
    if self.daily_usage
      self.daily_usage * 365.0 / 12.0
    else
      nil
    end
  end
  
  def today_stock #今日の推定在庫数量
    if lastcheck = self.checks.order(:date).last #最後の在庫確認時の数
      self.adds.where(date: lastcheck.date..Date.today).each do |add|
        lastcheck.number += add.number #入荷があれば足す
      end
      number = lastcheck.number.to_f - self.daily_usage.to_f * (Date.today - lastcheck.date) #使用量推定値を引く
      number > 0 ? number : 0.0
    else
      nil
    end
  end

  def stock_out_date #在庫切れの予測日
    Date.today + stock_days if stock_days = self.stock_days
  end
  
  def stock_days #在庫切れまでの日数
    if not_done_orders = self.not_done_orders
      ordered_stock = not_done_orders.map{ |o| o[:number] }.sum #未入荷の発注を合計
    else
      ordered_stock = 0.0
    end
    today_stock = self.today_stock
    if self.daily_usage and today_stock
      (ordered_stock + today_stock) / self.daily_usage
    else
      nil
    end
  end
  
  def stock_months #在庫切れまでの月数
    stock_days / 365.0 * 12.0 if stock_days = self.stock_days
  end
  
  def stock_condition #在庫の状態
    if self.daily_usage.to_f > 0 and stock_out_date = self.stock_out_date
      if stock_out_date < Date.today + self.lead_time
        return "danger" #在庫切れまでの日数がリードタイムより少ない
      elsif stock_out_date < Date.today + self.lead_time * 2
        return "warning" #在庫切れまでの日数がリードタイムx2より少ない
      else
        return "normal" #在庫は十分
      end
    else
		  return "N/A"
    end
  end

  def not_done_orders
    if Order.find_by(item_id: self.id)
      Order.where(item_id: self.id).where.not(status: "done")
    else
       nil
    end
  end

  def self.import(file) #CSVファイルのインポート
    item_count = Item.count
    CSV.foreach(file.path, headers: true) do |row|
      item = Item.new
      item.attributes = row.to_hash.slice(*item_attributes)
      item.save
    end
    Item.count - item_count
  end
  
  private

  def self.item_attributes
    ["name","code","category_id", "unit", "storage_location", "vendor_id", "lead_time"]
  end
end
