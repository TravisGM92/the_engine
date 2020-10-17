class InvoiceItem < ApplicationRecord
  validates_presence_of :item_id, :invoice_id, :quantity, :unit_price, :created_at, :updated_at

end
