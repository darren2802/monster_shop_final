require 'rails_helper'

RSpec.describe 'Coupon Edit' do
  before :each do
    @merchant = create :merchant
    @m_user = create(:user, merchant_id: @merchant.id)

    @coupon = create(:coupon, discount: 50, merchant_id: @merchant.id)
    @new_code = 'HF4JF'
    @new_name = 'SuperDiscount842'

    visit '/login'
    fill_in 'Email', with: @m_user.email
    fill_in 'Password', with: 'password'
    click_button 'Log In'
  end

  it 'can edit a coupon for a merchant' do
    visit '/merchant'

    click_link 'My Coupons'

    within "#coupon-#{@coupon.id}" do
      click_link 'Edit'
    end

    expect(current_path).to eq("/merchant/coupons/#{@coupon.id}/edit")

    within "#form-edit-coupon" do
      page.has_field?("#coupon-code", with: @coupon.code)
      page.has_field?("#coupon-name", with: @coupon.name)
      page.has_field?("#coupon-discount", with: @coupon.discount)

      fill_in 'code', with: @new_code
      fill_in 'name', with: @new_name
      page.select '25%', from: 'discount'

      click_button 'Save Coupon'
    end

    expect(current_path).to eq("/merchant/coupons")
    # expect(page).to have_content('Coupon updated successfully')

    within "#coupon-#{@coupon.id}" do
      expect(page).to have_content(@new_code)
      expect(page).to have_content(@new_name)
      expect(page).to have_content('25%')
    end
  end

  it 'cannot edit a coupon if information is missing' do
    visit '/merchant'

    click_link 'My Coupons'

    within "#coupon-#{@coupon.id}" do
      click_link 'Edit'
    end

    within "#form-edit-coupon" do
      page.has_field?("#coupon-code", with: @coupon.code)
      page.has_field?("#coupon-name", with: @coupon.name)
      page.has_field?("#coupon-discount", with: @coupon.discount)

      new_code = 'HF4JF'
      new_name = ''

      fill_in 'code', with: new_code
      fill_in 'name', with: new_name
      page.select '25%', from: 'discount'

      click_button 'Save Coupon'
    end

    # expect(page).to have_content('Coupon not updated, please try again')
  end
end
