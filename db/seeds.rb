# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

OrderItem.destroy_all
Order.destroy_all
User.destroy_all
Merchant.destroy_all
Item.destroy_all

merchants = FactoryBot.create_list(:merchant, 15)
items = []
merchants.each do |merchant|
  items << FactoryBot.create_list(:item, 30, merchant: merchant)
end
items.flatten!

users = FactoryBot.create_list(:user, 50)

counter = 0

loop do
  user = users.sample
  if !user.merchant_employee?
    user.update(merchant_id: merchants[counter].id, role: 1)
    counter += 1
  end
  break if counter == 15
end

counter = 0

orders = []
20.times do
  orders << Order.create(user_id: users.sample.id)
end

orders.each do |order|
  nr_items = rand(1..10)
  order_items = items.sample(nr_items)
  order_items.each do |order_item|
    OrderItem.create(item_id: order_item.id, order_id: order.id, price: order_item.price, quantity: rand(1..100))
  end
end
