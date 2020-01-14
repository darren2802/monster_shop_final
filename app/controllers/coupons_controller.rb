class CouponsController < ApplicationController
  def add_coupon
    cart.add_coupon(coupon_params['code'])
require "pry"; binding.pry
    redirect_to "/cart"
  end

  private
    def coupon_params
      params.permit :code
    end
end
