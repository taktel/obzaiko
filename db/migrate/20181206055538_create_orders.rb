class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.date :arrival_date
      t.references :item, foreign_key: true
      t.integer :number
      t.string :status
      t.references :order_sheet, foreign_key: true

      t.timestamps
    end
  end
end
