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
end
