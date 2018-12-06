class CreateVendors < ActiveRecord::Migration[5.0]
  def change
    create_table :vendors do |t|
      t.string :name
      t.string :contact
      t.string :email

      t.timestamps
    end
  end
end
