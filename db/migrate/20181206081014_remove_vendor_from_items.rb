class RemoveVendorFromItems < ActiveRecord::Migration[5.0]
  def change
    remove_column :items, :vendor, :string
  end
end
