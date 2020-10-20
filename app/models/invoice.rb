class Invoice < ApplicationRecord
  validates_presence_of :customer_id, :status, :merchant_id, :created_at, :updated_at
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :transactions

  belongs_to :merchant
  belongs_to :customer

  def self.most_expensive(limit = 5, sorting = "DESC")
  select("invoices.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue")
    .joins(:invoice_items, :transactions)
    .where(transactions: {result: "success"})
    .group(:id)
    .order("revenue #{sorting}")
    .limit(limit)
  end
end
