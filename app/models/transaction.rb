class Transaction < ApplicationRecord
  validates_presence_of :invoice_id, :credit_card_number, :result, :created_at, :updated_at
  validates_presence_of :credit_card_expiration_date, {allow_blank: true}
  belongs_to :invoice

  scope :successful, -> { where(result: "success") }

  def self.revenue_within_dates(start, finish)
    require "pry"; binding.pry
    # select('invoices.*').joins(invoices: [:invoice_items, :transactions]).where(invoices: {status: 'shipped'}).where(invoices: {updated_at: start..finish}).sum('invoice_items.quantity * invoice_items.unit_price').round(2)
  end
end
