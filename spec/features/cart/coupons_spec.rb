require 'rails_helper'

RSpec.describe 'Coupon CRUD' do
  describe 'As any type of user' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 2000, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 5000, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @user = User.create!(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      @coupon_megan = create(:coupon, code: 'LEGKR', name: 'KillerDiscount568', discount: 50, merchant_id: @megan.id)
      @coupon_brian = create(:coupon, code: 'BGRBR', name: 'GreatDeal432', discount: 25, merchant_id: @brian.id)
      visit item_path(@ogre)
      click_button 'Add to Cart'
      visit item_path(@giant)
      click_button 'Add to Cart'
    end

    it 'can add a coupon and apply it to items in a cart' do
      visit "/cart"

      within "#form-add-coupon" do
        fill_in 'Code', with: 'LEGKR'
        click_button 'Add Coupon'
      end

      within "#coupon-#{@coupon_megan.id}" do
        expect(page).to have_content('LEGKR')
        expect(page).to have_content('KillerDiscount568')
        click_button 'Apply'
      end

      expect(page).to have_content('Coupon applied to relevant items')

      within "#item-#{@ogre.id}" do
        expect(page).to have_content('LEGKR')
        expect(page).to have_content('50%')
        expect(page).to have_content('$20.00')
        expect(page).to have_content('$10.00')
      end
    end

    it 'can add a coupon that cannot be applied to any items in a cart' do
      visit "/cart"

      within "#form-add-coupon" do
        fill_in 'Code', with: 'BGRBR'
        click_button 'Add Coupon'
      end

      within "#coupon-#{@coupon_brian.id}" do
        expect(page).to have_content('BGRBR')
        expect(page).to have_content('GreatDeal432')
        click_button 'Apply'
      end

      expect(page).to have_content('Coupon could not be applied to any items')

      within "#item-#{@ogre.id}" do
        expect(page).to have_no_content('BGRBR')
        expect(page).to have_no_content('25%')
      end
    end

    it 'can add a coupon apply it and then remove it from a cart' do
      visit "/cart"

      within "#form-add-coupon" do
        fill_in 'Code', with: 'LEGKR'
        click_button 'Add Coupon'
      end

      within "#coupon-#{@coupon_megan.id}" do
        expect(page).to have_content('LEGKR')
        expect(page).to have_content('KillerDiscount568')
        click_button 'Apply'
      end

      expect(page).to have_content('Coupon applied to relevant items')

      within "#coupon-#{@coupon_megan.id}" do
        click_button 'Remove'
      end

      expect(page).to have_content('Coupon removed from cart')

      within "#item-#{@ogre.id}" do
        expect(page).to have_no_content('LEGKR')
        expect(page).to have_no_content('50%')
        expect(page).to have_no_content('$10.00')
      end
    end

    it 'can add a coupon and then delete it' do
      visit "/cart"

      within "#form-add-coupon" do
        fill_in 'Code', with: 'LEGKR'
        click_button 'Add Coupon'
      end

      within "#coupon-#{@coupon_megan.id}" do
        expect(page).to have_content('LEGKR')
        expect(page).to have_content('KillerDiscount568')
        click_button 'Apply'
      end

      expect(page).to have_content('Coupon applied to relevant items')

      within "#coupon-#{@coupon_megan.id}" do
        click_button 'Delete'
      end

      expect(page).to have_content('Coupon deleted')
      expect(page).to have_no_content('LEGKR')
      expect(page).to have_no_content('50%')
    end
  end
end
