# frozen_string_literal: true

class Item < ApplicationRecord
  self.primary_key = 'id'
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  validates_presence_of :name, :description, :unit_price, :merchant_id, :created_at, :updated_at
end
