FactoryBot.define do
  factory :item do
    name { "Toolbox" }
    description { "The nicest!" }
    unit_price { 3.99 }
    merchant_id { 4 }
  end
end
