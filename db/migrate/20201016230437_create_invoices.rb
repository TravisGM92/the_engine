# frozen_string_literal: true

class CreateInvoices < ActiveRecord::Migration[5.2]
  def change
    create_table :invoices do |t|
      t.string :status

      t.timestamps null: false
    end
  end
end
