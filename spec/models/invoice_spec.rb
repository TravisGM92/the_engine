require 'rails_helper'

describe Invoice, type: :model do
  describe 'validations' do
    it {should validate_presence_of :customer_id}
    it {should validate_presence_of :status}
    it {should validate_presence_of :merchant_id}
    it {should validate_presence_of :created_at}
    it {should validate_presence_of :updated_at}
  end
  describe "relationships" do
    it {should have_many :invoice_items }
    it {should have_many :items }
    it {should have_many :transactions }

    it {should belong_to :merchant }
    it {should belong_to :customer }
  end
end
