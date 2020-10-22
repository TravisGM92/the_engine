# frozen_string_literal: true

require 'rails_helper'

describe Invoice, type: :model do
  describe 'validations' do
    it { should validate_presence_of :customer_id }
    it { should validate_presence_of :status }
    it { should validate_presence_of :merchant_id }
    it { should validate_presence_of :created_at }
    it { should validate_presence_of :updated_at }
  end
  describe 'relationships' do
    it { should have_many :invoice_items }
    it { should have_many :items }
    it { should have_many :transactions }

    it { should belong_to :merchant }
    it { should belong_to :customer }
  end

  describe '.most_expensive(limit, sorting)' do
    it 'can put a limit as a passed in argument' do
      customer = create(:customer)
      merchant = create(:merchant)
      create(:invoice, customer_id: customer.id, merchant_id: merchant.id)
      Invoice.most_expensive(limit = 1)
    end
  end
end
