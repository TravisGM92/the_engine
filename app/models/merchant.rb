class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices
  has_many :invoice_items, through: :invoices
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices
  validates_presence_of :name, :created_at, :updated_at

  def self.downcase_split_names(name)
    name.downcase.split(" ")
  end

  def self.highest_revenue(limit)
    select("merchants.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue").joins(:invoices).joins(:transactions).joins(:invoice_items).merge(Transaction.successful).group(:id).order("revenue DESC").limit(limit)
  end
end
