class CreateOrderSheets < ActiveRecord::Migration[5.0]
  def change
    create_table :order_sheets do |t|
      t.date :order_date
      t.string :code
      t.string :vendor
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
