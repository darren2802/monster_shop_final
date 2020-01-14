class Cart
  attr_reader :contents

  def initialize(contents)
      # @contents = contents || { 'items' => Hash.new(0), 'coupon' => Hash.new() }
      @contents = contents || Hash.new{ |h,k| h[k] = Hash.new(0) }
  end

  def add_item(item_id)
    @contents['items'][item_id] = 0 if !@contents['items'][item_id]
    @contents['items'][item_id] += 1
  end

  def less_item(item_id)
    @contents['items'][item_id] -= 1
  end

  def count
    @contents['items'].values.sum
  end

  def items
    @contents['items'].map do |item_id, _|
      Item.find(item_id)
    end
  end

  def grand_total
    grand_total = 0.0
    @contents['items'].each do |item_id, quantity|
      grand_total += Item.find(item_id).price / 100 * quantity
    end
    grand_total
  end

  def count_of(item_id)
    @contents['items'][item_id.to_s]
  end

  def subtotal_of(item_id)
    @contents['items'][item_id.to_s] * Item.find(item_id).price / 100
  end

  def limit_reached?(item_id)
    count_of(item_id) == Item.find(item_id).inventory
  end

  def add_coupon(coupon_code)
    coupon_code.upcase!
    @contents['coupons'] = Hash.new{ |h,k| h[k] = Hash.new} if !@contents['coupons']
    coupon = Coupon.where('coupons.code = ?', coupon_code)[0]
    merchant = Merchant.find(coupon.merchant_id)
    @contents['coupons'][coupon_code]['id'] = coupon.id
    @contents['coupons'][coupon_code]['name'] = coupon.name
    @contents['coupons'][coupon_code]['merchant_id'] = coupon.merchant_id
    @contents['coupons'][coupon_code]['merchant_name'] = merchant.name
    @contents['coupons'][coupon_code]['discount'] = coupon.discount
  end

  def coupons
    @contents['coupons']
  end
end
