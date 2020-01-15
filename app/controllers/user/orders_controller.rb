class User::OrdersController < ApplicationController
  before_action :exclude_admin

  def index
    @orders = current_user.orders
  end

  def show
    @order = current_user.orders.find(params[:id])
  end

  def create
    order = current_user.orders.new
    order.save
      cart.items.each do |item|
        if get_coupon(item.merchant_id)
          coupon = get_coupon(item.merchant_id)
        else
          coupon = nil
        end
        order.order_items.create({
          item: item,
          quantity: cart.count_of(item.id),
          price: item.price,
          coupon: coupon
          })
      end
    session.delete(:cart)
    flash[:success] = "Order created successfully!"
    redirect_to '/profile/orders'
  end

  def get_coupon(merchant_id)
    coupon_id = ''
    if cart.coupons
      cart.coupons.each do |coupon_code,coupon_details|
        if coupon_details['merchant_id'] = merchant_id && coupon_details['apply'] == true
          coupon_id = coupon_details['id']
        end
      end
      return nil if coupon_id == ''
      Coupon.find(coupon_id)
    else
      return nil
    end
  end

  def cancel
    order = current_user.orders.find(params[:id])
    order.cancel
    redirect_to "/profile/orders/#{order.id}"
  end
end
