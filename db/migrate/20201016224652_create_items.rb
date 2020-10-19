class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items, id: false do |t|
      t.string :id
      t.string :name
      t.string :description
      t.float :unit_price
      t.integer :merchant_id

      t.timestamps null: false
    end
  end
end
