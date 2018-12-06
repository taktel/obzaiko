class Item < ApplicationRecord
  require 'csv'
  belongs_to :category
  belongs_to :vendor
  
  validates :name, presence: true, length: { maximum: 50 }
  validates :code, length: { maximum: 50 }
  validates :unit, presence: true, length: { maximum: 10 }
  validates :storage_location, length: { maximum: 50 }
  validates :lead_time, presence: true
  
  has_many :inventories, dependent: :destroy
  has_many :adds, dependent: :destroy
  has_many :checks, dependent: :destroy
  has_many :orders, dependent: :destroy
  
  def dayly_usage
    if self.monthly_usage
      self.monthly_usage / 365.0 * 12.0
    else
      nil
    end
  end
  
  def today_stock
    if lastcheck = self.checks.order(:date).last
      self.adds.where(date: lastcheck.date..Date.today).each do |add|
        lastcheck.number += add.number
      end
      number = lastcheck.number.to_f - self.dayly_usage.to_f * (Date.today - lastcheck.date)
      number > 0 ? number : 0.0
    else
      nil
    end
  end

  def stock_out_date
    if self.today_stock
      Date.today + self.today_stock / self.dayly_usage
    else
      nil
    end
  end
  
  def stock_condition
    if self.monthly_usage.to_f > 0 and stock_out_date = self.stock_out_date
      if stock_out_date < Date.today + self.lead_time
        return "danger"
      elsif stock_out_date < Date.today + self.lead_time * 2
        return "warning"
      else
        return "normal"
      end
    else
		  return "N/A"
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
