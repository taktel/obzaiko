class CreateInventories < ActiveRecord::Migration[5.0]
  def change
    create_table :inventories do |t|
      t.string :type
      t.date :date
      t.integer :number
      t.references :user, foreign_key: true
      t.references :item, foreign_key: true

      t.timestamps
      
      t.index [:type, :date, :item_id], unique: true
    end
  end
end
