require 'rails_helper'

RSpec.describe Cart do
  describe 'Instance Methods' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 2000, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 5000, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 2 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 5000, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @cart = Cart.new({
        'items' => {
        @ogre.id.to_s => 1,
        @giant.id.to_s => 2
        }})
      @coupon = create(:coupon, code: 'LEGKR', name: 'KillerDiscount568', discount: 50, merchant_id: @megan.id)
    end

    it '.contents' do
      expect(@cart.contents).to eq({
        'items' => {
        @ogre.id.to_s => 1,
        @giant.id.to_s => 2
        }})
    end

    it '.add_item()' do
      @cart.add_item(@hippo.id.to_s)

      expect(@cart.contents).to eq({
        'items' => {
        @ogre.id.to_s => 1,
        @giant.id.to_s => 2,
        @hippo.id.to_s => 1
        }})
    end

    it '.count' do
      expect(@cart.count).to eq(3)
    end

    it '.items' do
      expect(@cart.items).to eq([@ogre, @giant])
    end

    it '.grand_total' do
      expect(@cart.grand_total).to eq(120)
    end

    it '.count_of()' do
      expect(@cart.count_of(@ogre.id)).to eq(1)
      expect(@cart.count_of(@giant.id)).to eq(2)
    end

    it '.subtotal_of()' do
      expect(@cart.subtotal_of(@ogre.id)).to eq(20)
      expect(@cart.subtotal_of(@giant.id)).to eq(100)
    end

    it '.discounted_subtotal_of()' do
      @cart.add_coupon('LEGKR')
      @cart.apply_coupon('LEGKR')

      expect(@cart.discounted_subtotal_of(@ogre.id, @coupon.discount)).to eq(10)
    end

    it '.limit_reached?()' do
      expect(@cart.limit_reached?(@ogre.id)).to eq(false)
      expect(@cart.limit_reached?(@giant.id)).to eq(true)
    end

    it '.less_item()' do
      @cart.less_item(@giant.id.to_s)

      expect(@cart.count_of(@giant.id)).to eq(1)
    end

    it '.add_coupon()' do
      @cart.add_coupon('LEGKR')

      expect(@cart.contents).to eq({
        "items"=>{@ogre.id.to_s=>1, @giant.id.to_s=>2},
         "coupons"=>
          { 'LEGKR' =>
            {"id" => @coupon.id,
             "name"=> "KillerDiscount568",
             "merchant_id" => @megan.id,
             "merchant_name" => "Megans Marmalades",
             "discount"=> 50,
             "apply"=>false}}})
    end

    it '.apply_coupon()' do
      @cart.add_coupon('LEGKR')
      @cart.apply_coupon('LEGKR')

      expect(@cart.contents['coupons']['LEGKR']['apply']).to be true
    end

    it '.remove_coupon()' do
      @cart.add_coupon('LEGKR')
      @cart.apply_coupon('LEGKR')

      expect(@cart.contents['coupons']['LEGKR']['apply']).to be true

      @cart.remove_coupon('LEGKR')

      expect(@cart.contents['coupons']['LEGKR']['apply']).to be false
    end

    it '.destroy_coupon()' do
      @cart.add_coupon('LEGKR')

      expect(@cart.contents['coupons'].keys).to eq(['LEGKR'])

      @cart.destroy_coupon('LEGKR')

      expect(@cart.contents['coupons'].empty?).to be true
    end

    it '.item_has_relevant_coupon()' do
      @cart.add_coupon('LEGKR')
      @cart.apply_coupon('LEGKR')

      expect(@cart.item_has_relevant_coupon(@megan.id)).to be true

      expect(@cart.item_has_relevant_coupon(@brian.id)).to be false
    end

    it '.coupons' do
      @cart.add_coupon('LEGKR')

      expect(@cart.coupons).to eq({ 'LEGKR' =>
        {"id" => @coupon.id,
         "name"=> "KillerDiscount568",
         "merchant_id" => @megan.id,
         "merchant_name" => "Megans Marmalades",
         "discount"=> 50,
         "apply"=>false}})
    end
  end
end
