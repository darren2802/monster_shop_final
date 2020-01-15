class CouponsController < ApplicationController
  def add_coupon
    cart.add_coupon(coupon_params['code'])

    redirect_to "/cart"
  end

  def apply_coupon
    if cart.apply_coupon(params[:coupon_code])
      flash[:success] = 'Coupon applied to relevant items'
    else
      flash[:error] = 'Coupon could not be applied to any items'
    end

    redirect_to "/cart"
  end

  def remove_coupon
    cart.remove_coupon(params[:coupon_code])
    flash[:notice] = 'Coupon removed from cart'
    redirect_to "/cart"
  end

  def destroy

  end

  private
    def coupon_params
      params.permit :code
    end
end
