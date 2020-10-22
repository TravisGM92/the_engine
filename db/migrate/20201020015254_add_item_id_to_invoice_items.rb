# frozen_string_literal: true

class AddItemIdToInvoiceItems < ActiveRecord::Migration[5.2]
  def change
    add_reference :invoice_items, :item, foreign_key: true
  end
end
