require 'rails_helper'

describe Transaction, type: :model do
  describe 'validations' do
    it {should validate_presence_of :invoice_id}
    it {should validate_presence_of :credit_card_number}
    it {should validate_presence_of :result}
    it {should validate_presence_of :created_at}
    it {should validate_presence_of :updated_at}
  end

  describe 'relationships' do
    it {should belong_to :invoice}
  end

  describe ".succcessful" do
    it 'only finds the successful transactions' do
      invoices = []
      result = []
      5.times do
        customer = create(:customer)
        merchant = create(:merchant)
        invoices << create(:invoice, customer_id: customer.id, merchant_id: merchant.id)
      end
      2.times do
        result << create(:transaction, invoice_id: invoices.pop.id, result: 'success')
      end
      2.times do
        create(:transaction, invoice_id: invoices.pop.id, result: 'failed')
      end
      expect(Transaction.successful).to eq(result)
    end
  end

end
