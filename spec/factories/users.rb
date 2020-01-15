require 'BCrypt'

FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    address { Faker::Address.street_address }
    city { Faker::Address.city }
    state { Faker::Address.state }
    zip { Faker::Address.zip.to_i }
    email { Faker::Internet.email }
    password_digest { BCrypt::Password.create('password') }
  end
end
