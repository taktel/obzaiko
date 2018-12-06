class RemoveVendorFromOrderSheets < ActiveRecord::Migration[5.0]
  def change
    remove_column :order_sheets, :vendor, :string
  end
end
