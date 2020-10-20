FactoryBot.define do
  FactoryBot.define do
    factory :transaction do
      credit_card_number { Faker::Business.credit_card_number }
      credit_card_expiration_date { Faker::Business.credit_card_expiry_date }
      result { "success" }
      created_at { Faker::Date.between(from: 100.days.ago, to: Date.today) }
      updated_at { Faker::Date.between(from: 200.days.ago, to: Date.today) }
    end
  end
end
