class CreateItems < ActiveRecord::Migration[5.0]
  def change
    create_table :items do |t|
      t.string :name
      t.string :code
      t.references :category, foreign_key: true
      t.string :unit
      t.string :storage_location
      t.string :vendor
      t.float :lead_time

      t.timestamps
    end
  end
end
