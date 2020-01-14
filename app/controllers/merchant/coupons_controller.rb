class Merchant::CouponsController < Merchant::BaseController
  def index
    @coupons = current_user.merchant.coupons
  end

  def create
    merchant = Merchant.find(current_user.merchant_id)
    if merchant.coupons.coupon_limit_met
      flash[:notice] = 'Coupon limit of 5 cannot be exceeded'
    else
      new_coupon = merchant.coupons.create(coupon_params)
      if new_coupon.save
        flash[:notice] = 'Coupon added successfully'
      else
        flash[:notice] = 'Coupon could not be added, please try again'
      end
    end
    @coupons = merchant.coupons

    render :index
  end

  private
    def coupon_params
      params.permit :code, :name, :discount
    end
end
