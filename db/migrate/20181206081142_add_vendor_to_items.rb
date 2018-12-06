class AddVendorToItems < ActiveRecord::Migration[5.0]
  def change
    add_reference :items, :vendor, foreign_key: true
  end
end
