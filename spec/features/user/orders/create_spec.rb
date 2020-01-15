require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.describe 'Create Order' do
  describe 'As a Registered User' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 2000, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 5000, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 5000, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @user = User.create!(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      @coupon = create(:coupon, code: 'LEGKR', name: 'KillerDiscount568', discount: 50, merchant_id: @megan.id)

      visit "/login"
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: 'securepassword'
      click_button 'Log In'
    end

    it 'I can click a link to to create an order' do
      visit item_path(@ogre)
      click_button 'Add to Cart'
      visit item_path(@hippo)
      click_button 'Add to Cart'
      visit item_path(@hippo)
      click_button 'Add to Cart'

      visit '/cart'

      click_button 'Check Out'

      order = Order.last

      expect(current_path).to eq('/profile/orders')
      expect(page).to have_content('Order created successfully!')
      expect(page).to have_link('Cart: 0')

      within "#order-#{order.id}" do
        expect(page).to have_link("#{order.id}")
      end
    end

    it 'I can click a link to create an order with coupons' do
      visit item_path(@ogre)
      click_button 'Add to Cart'
      visit item_path(@hippo)
      click_button 'Add to Cart'
      visit item_path(@hippo)
      click_button 'Add to Cart'

      visit '/cart'

      within '#form-add-coupon' do
        fill_in 'Code', with: 'LEGKR'
        click_button 'Add Coupon'
      end

      within "#coupon-#{@coupon.id}" do
        expect(page).to have_content(@coupon.id)
        expect(page).to have_content('LEGKR')
        expect(page).to have_content('KillerDiscount568')
        expect(page).to have_content("#{@coupon.discount}%")
        expect(page).to have_content(@megan.name)
        expect(page).to have_button("Apply")
        expect(page).to have_button("Remove")
        expect(page).to have_button("Delete")
        click_button "Apply"
      end

      within "#item-#{@ogre.id}" do
        expect(page).to have_content('LEGKR')
        expect(page).to have_content('50%')
        expect(page).to have_content('$20.00')
        expect(page).to have_content('$10.00')
      end

      click_button 'Check Out'

      order = Order.last
    end
  end

  describe 'As a Visitor' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
    end

    it "I see a link to log in or register to check out" do
      visit item_path(@ogre)
      click_button 'Add to Cart'
      visit item_path(@hippo)
      click_button 'Add to Cart'
      visit item_path(@hippo)
      click_button 'Add to Cart'

      visit '/cart'

      expect(page).to_not have_button('Check Out')

      within '#checkout' do
        click_link 'register'
      end

      expect(current_path).to eq(registration_path)

      visit '/cart'

      within '#checkout' do
        click_link 'log in'
      end

      expect(current_path).to eq(login_path)
    end
  end
end
