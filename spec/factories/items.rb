FactoryBot.define do
  factory :item do
    name { Faker::Appliance.equipment }
    description { Faker::Appliance.brand }
    image { Faker::LoremFlickr.image(size: "400x400", search_terms: ['home','appliance'])}
    price { Faker::Number.between(from: 1000, to: 100000) }
    inventory { Faker::Number.between(from: 1, to: 50) }
  end
end
