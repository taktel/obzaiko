class AddNameEnToItems < ActiveRecord::Migration[5.0]
  def change
    add_column :items, :name_en, :string
  end
end
