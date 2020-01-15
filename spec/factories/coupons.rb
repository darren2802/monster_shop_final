FactoryBot.define do
  factory :coupon do
    code { Faker::Alphanumeric.alphanumeric(number: 5).upcase }
    name { Faker::Commerce.promotion_code(digits: 0) + '%03d' % rand(0..999) }
    discount { [5,10,25,50,75,100].sample }
  end
end
