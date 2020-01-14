require 'rails_helper'

RSpec.describe 'Coupon Delete' do
  before :each do
    @merchant = create :merchant
    @m_user = create(:user, merchant_id: @merchant.id)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
    @coupon = create(:coupon, merchant_id: @merchant.id)
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
