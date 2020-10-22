class Transaction < ApplicationRecord
  validates_presence_of :invoice_id, :credit_card_number, :result, :created_at, :updated_at
  validates_presence_of :credit_card_expiration_date, {allow_blank: true}
  belongs_to :invoice

  scope :successful, -> { where(result: "success") }
end
