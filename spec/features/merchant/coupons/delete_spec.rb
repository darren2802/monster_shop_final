require 'rails_helper'

RSpec.describe 'Coupon Delete' do
  before :each do
    @merchant = create :merchant
    @m_user = create(:user, merchant_id: @merchant.id)
    @coupon = create(:coupon, merchant_id: @merchant.id)

    visit '/login'
    fill_in 'Email', with: @m_user.email
    fill_in 'Password', with: 'password'
    click_button 'Log In'
  end

  it 'can delete a coupon for a merchant' do
    visit '/merchant'

    click_link 'My Coupons'

    expect(current_path).to eq("/merchant/coupons")

    within "#coupon-#{@coupon.id}" do
      click_link 'Delete'
    end

    expect(current_path).to eq("/merchant/coupons")
    expect(page).to have_content('Coupon deleted')

    expect(page).to have_no_css("#coupon-#{@coupon.id}")
  end
end
