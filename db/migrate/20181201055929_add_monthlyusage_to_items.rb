class AddMonthlyusageToItems < ActiveRecord::Migration[5.0]
  def change
    add_column :items, :monthly_usage, :float
  end
end
