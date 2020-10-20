class Invoice < ApplicationRecord
  validates_presence_of :customer_id, :status, :merchant_id, :created_at, :updated_at
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :transactions

  belongs_to :merchant
  belongs_to :customer
end
