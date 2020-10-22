# frozen_string_literal: true

FactoryBot.define do
  factory :item do
    name { Faker::Commerce.material }
    description { Faker::Lorem.paragraph }
    unit_price { Faker::Number.within(range: 1..9000) }
    merchant_id { Faker::Number.within(range: 1..900) }
    created_at { Faker::Date.between(from: 100.days.ago, to: Date.today) }
    updated_at { Faker::Date.between(from: 200.days.ago, to: Date.today) }
    merchant
  end
end
