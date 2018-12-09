class AddOrderIdToInventories < ActiveRecord::Migration[5.0]
  def change
    add_reference :inventories, :order, foreign_key: true
  end
end
