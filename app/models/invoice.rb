class Invoice < ApplicationRecord
  validates_presence_of :customer_id, :status, :merchant_id, :created_at, :updated_at

end
