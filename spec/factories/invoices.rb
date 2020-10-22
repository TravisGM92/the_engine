# frozen_string_literal: true

FactoryBot.define do
  factory :invoice do
    status { 'pending' }
    created_at { Faker::Date.between(from: 100.days.ago, to: Date.today) }
    updated_at { Faker::Date.between(from: 200.days.ago, to: Date.today) }
  end
end
