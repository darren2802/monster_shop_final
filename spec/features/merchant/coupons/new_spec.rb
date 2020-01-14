require 'rails_helper'

RSpec.describe 'Coupon Index Page' do
  before :each do
    @merchant = create :merchant
    @m_user = create(:user, merchant_id: @merchant.id)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
    @code = Faker::Alphanumeric.alphanumeric(number: 5).upcase
    @name = Faker::Commerce.promotion_code(digits: 0) + '%03d' % rand(0..999)
  end

  it 'can save a new coupon for a merchant' do
    visit '/merchant'

    click_link 'My Coupons'

    within "#form-new-code" do
      fill_in 'Code', with: @code
      fill_in 'Name', with: @name
      page.select '25%', from: 'discount'
      click_button 'Add Coupon'
    end

    expect(current_path).to eq("/merchant/coupons")
    expect(page).to have_content('Coupon added successfully')

    new_coupon = Coupon.last

    within "#coupon-#{new_coupon.id}" do
      expect(page).to have_content(new_coupon.code)
      expect(page).to have_content(new_coupon.name)
      expect(page).to have_content(new_coupon.discount)
    end
  end

  it 'will not create a coupon if merchant has 5 or more coupons already' do
    create_list(:coupon, 5, merchant_id: @merchant.id)

    visit '/merchant'

    click_link 'My Coupons'

    within "#form-new-code" do
      fill_in 'Code', with: @code
      fill_in 'Name', with: @name
      page.select '25%', from: 'discount'
      click_button 'Add Coupon'
    end

    expect(current_path).to eq("/merchant/coupons")
    expect(page).to have_content('Coupon limit of 5 cannot be exceeded')
  end
end
