# frozen_string_literal: true

class CreateInvoiceItems < ActiveRecord::Migration[5.2]
  def change
    create_table :invoice_items do |t|
      t.integer :quantity
      t.float :unit_price

      t.timestamps null: false
    end
  end
end
