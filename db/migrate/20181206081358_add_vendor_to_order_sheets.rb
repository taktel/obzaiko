class AddVendorToOrderSheets < ActiveRecord::Migration[5.0]
  def change
    add_reference :order_sheets, :vendor, foreign_key: true
  end
end
