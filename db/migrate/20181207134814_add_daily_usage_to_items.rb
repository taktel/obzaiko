class AddDailyUsageToItems < ActiveRecord::Migration[5.0]
  def change
    add_column :items, :daily_usage, :float
  end
end
