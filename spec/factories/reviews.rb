FactoryBot.define do
  factory :review do
    title { Faker::Quotes::Shakespeare.as_you_like_it_quote }
    description { Faker::Quote.matz }
    rating { Faker::Number.between(from: 1, to: 5) }
  end
end
