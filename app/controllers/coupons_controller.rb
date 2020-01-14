class CouponsController < ApplicationController
  def add_coupon
    cart.add_coupon(coupon_params['code'])

    redirect_to "/cart"
  end

  def apply_coupon
    cart.apply_coupon(params[:coupon_code])

    redirect_to "/cart"
  end

  def remove_coupon

  end

  private
    def coupon_params
      params.permit :code
    end
end
