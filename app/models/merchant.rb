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
    joins(invoices: [:invoice_items, :transactions])
      .merge(Transaction.successful)
      .group('merchants.id')
      .order('sum(invoice_items.quantity * invoice_items.unit_price) desc')
      .limit(limit)
  end

  def self.most_items(limit)
    joins(invoices: [:invoice_items, :transactions])
      .merge(Transaction.successful)
      .group('merchants.id')
      .order('sum(invoice_items.quantity * 1) DESC')
      .limit(limit)
  end

  def self.revenue_within_dates(start, finish)
    select('transactions.*').joins(invoices: [:invoice_items, :transactions]).where(transactions: {created_at: start..finish}).sum('invoice_items.quantity * invoice_items.unit_price')
  end
end
