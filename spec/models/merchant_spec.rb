require 'rails_helper'

describe Merchant, type: :model do
  describe 'validations' do
    it {should validate_presence_of :name}
    it {should validate_presence_of :created_at}
    it {should validate_presence_of :updated_at}
  end

  describe "relationships" do
    it {should have_many :items}
    it {should have_many :invoices}
    it {should have_many :invoice_items}
    it {should have_many :transactions}
    it {should have_many :customers}
  end

  describe ".most_revenue(quantity)" do
    it "calcualtes the 'quantity' number of merchants with highest revenue" do

        merchants = create_list(:merchant, 3)
        customers = create_list(:customer, 3)
        invoices = []
        merchants.each{ |merchant| create_list(:item, 2, merchant_id: merchant.id)}
        merchants.each{ |merchant| customers.each{ |customer| invoices << create(:invoice, merchant_id: merchant.id, customer_id: customer.id)}}
        invoices.each{ |invoice| create(:transaction, invoice_id: invoice.id)}

        x = 0
        invoices.each do |invoice|
          create(:invoice_item, invoice_id: invoice.id, quantity: x += 100, unit_price: 10)
        end
        expected = merchants[-2..-1].sort.reverse


      expect(Merchant.highest_revenue(2)).to eq(expected)
    end
  end
end
