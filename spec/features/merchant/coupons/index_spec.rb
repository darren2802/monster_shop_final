require 'rails_helper'

RSpec.describe 'Coupon Index Page' do
  before :each do
    @merchant = create :merchant
    @m_user = create(:user, merchant_id: @merchant.id)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
    @coupons = create_list(:coupon, 5, merchant_id: @merchant.id)
  end

  it 'can display a list of coupons for a merchant' do
    visit '/merchant'

    click_link 'My Coupons'

    expect(current_path).to eq("/merchant/coupons")

    @coupons.each do |coupon|
      within "#coupon-#{coupon.id}" do
        expect(page).to have_content(coupon.code)
        expect(page).to have_content(coupon.name)
        expect(page).to have_content(coupon.discount)
      end
    end
  end
end
