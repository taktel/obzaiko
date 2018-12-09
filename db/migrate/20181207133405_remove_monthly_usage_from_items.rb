class RemoveMonthlyUsageFromItems < ActiveRecord::Migration[5.0]
  def change
    remove_column :items, :monthly_usage, :float
  end
end
