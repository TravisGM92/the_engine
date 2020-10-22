# frozen_string_literal: true

class AddInvoiceIdToTransactions < ActiveRecord::Migration[5.2]
  def change
    add_reference :transactions, :invoice, foreign_key: true
  end
end
