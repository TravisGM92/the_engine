# frozen_string_literal: true

class AddInvoiceIdToInvoiceItems < ActiveRecord::Migration[5.2]
  def change
    add_reference :invoice_items, :invoice, foreign_key: true
  end
end
