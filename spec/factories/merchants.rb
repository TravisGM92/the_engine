FactoryBot.define do
  FactoryBot.define do
    factory :merchant do
      name { Faker::Name.first_name }
      created_at { Faker::Date.between(from: 100.days.ago, to: Date.today) }
      updated_at { Faker::Date.between(from: 200.days.ago, to: Date.today) }
    end
  end
end
