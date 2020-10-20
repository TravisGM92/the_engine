FactoryBot.define do
  factory :invoice_item do
    quantity { Faker::Number.within(range: 1..9000) }
    unit_price { item.unit_price }
    created_at { Faker::Date.between(from: 100.days.ago, to: Date.today) }
    updated_at { Faker::Date.between(from: 200.days.ago, to: Date.today) }
    item
  end
end
