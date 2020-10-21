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

  describe ".most_items(quantity)" do
    it "grabs the merchants who have sold the most items" do

        merchants = create_list(:merchant, 6)
        customers = create_list(:customer, 6)
        invoices = []
        merchants.each{ |merchant| create_list(:item, 2, merchant_id: merchant.id)}
        merchants.each{ |merchant| customers.each{ |customer| invoices << create(:invoice, merchant_id: merchant.id, customer_id: customer.id)}}
        invoices.each{ |invoice| create(:transaction, invoice_id: invoice.id)}

        x = 0
        invoices.each do |invoice|
          create(:invoice_item, invoice_id: invoice.id, quantity: x += 100, unit_price: 10)
        end
        expected = merchants[-4..-1].sort.reverse

      expect(Merchant.most_items(4)).to eq(expected)
    end
  end

  describe ".revenue_within_dates(start, end)" do
    it "grabs the merchants who have sold the most items" do

      merchants = create_list(:merchant, 3)
      customers = create_list(:customer, 3)
      invoices = []
      merchants.each{ |merchant| create_list(:item, 2, merchant_id: merchant.id)}
      merchants.each{ |merchant| customers.each{ |customer| invoices << create(:invoice, merchant_id: merchant.id, customer_id: customer.id)}}
      invoices[0..4].each{ |invoice| create(:transaction, invoice_id: invoice.id)}
      x = 0
      invoices[0..4].each do |invoice|
        create(:invoice_item, invoice_id: invoice.id, quantity: x += 200, unit_price: 10)
      end

      expect(Merchant.revenue_within_dates("1990-01-01", "2022-03-24")).to eq(InvoiceItem.sum('quantity * unit_price'))


      invoices[5..8].each do |invoice|
        create(:invoice_item, invoice_id: invoice.id, quantity: x += 300, unit_price: 10)
      end
      invoices[5..8].each{ |invoice| create(:transaction, invoice_id: invoice.id)}
      
      expect(Merchant.revenue_within_dates("1990-01-01", "2022-03-24")).to eq(InvoiceItem.sum('quantity * unit_price'))
    end
  end
end
