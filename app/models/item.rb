class Item < ApplicationRecord
  self.primary_key = "id"
  belongs_to :merchant
  validates_presence_of :name, :description, :unit_price, :merchant_id, :created_at, :updated_at
end
