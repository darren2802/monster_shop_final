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

  def subtotal_of(item_id)
    @contents['items'][item_id.to_s] * Item.find(item_id).price / 100
  end

  def discounted_subtotal_of(item_id, discount)
    subtotal_of(item_id) * (100 - discount) / 100
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

  def limit_reached?(item_id)
    count_of(item_id) == Item.find(item_id).inventory
  end

  def add_coupon(coupon_code)
    coupon_code.upcase!
    @contents['coupons'] = Hash.new if !@contents['coupons']
    coupon = Coupon.where('coupons.code = ?', coupon_code)[0]
    merchant = Merchant.find(coupon.merchant_id)
    @contents['coupons'][coupon_code] = Hash.new
    @contents['coupons'][coupon_code]['id'] = coupon.id
    @contents['coupons'][coupon_code]['name'] = coupon.name
    @contents['coupons'][coupon_code]['merchant_id'] = coupon.merchant_id
    @contents['coupons'][coupon_code]['merchant_name'] = merchant.name
    @contents['coupons'][coupon_code]['discount'] = coupon.discount
    @contents['coupons'][coupon_code]['apply'] = false
  end

  def apply_coupon(coupon_code)
    @contents['coupons'].each do |coupon_code,coupon_details|
      return false if coupon_details['apply'] == true
    end
    @contents['coupons'][coupon_code]['apply'] = true

    coupon_merchant_id = @contents['coupons'][coupon_code]['merchant_id']
    items_item_ids = @contents['items'].keys
    items_merchant_ids = items_item_ids.map { |item_id| Item.find(item_id).merchant_id }
    items_merchant_ids.any? { |id| id == coupon_merchant_id }
  end

  def item_has_relevant_coupon(merchant_id)
    if @contents['coupons']
      @contents['coupons'].each do |coupon_code,coupon_details|
        return true if merchant_id == coupon_details['merchant_id'] && coupon_details['apply'] == true
      end
    end
    return false
  end

  def remove_coupon(coupon_code)
    @contents['coupons'][coupon_code]['apply'] = false
  end

  def destroy_coupon(coupon_code)
    @contents['coupons'].delete(coupon_code)
  end

  def coupons
    @contents['coupons']
  end
end
