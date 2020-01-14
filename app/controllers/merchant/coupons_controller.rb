class Merchant::CouponsController < Merchant::BaseController
  def index
    @coupons = current_user.merchant.coupons
  end

  def create
    merchant = Merchant.find(current_user.merchant_id)
    if merchant.coupons.coupon_limit_met
      flash.now[:danger] = 'Coupon limit of 5 cannot be exceeded'
    else
      new_coupon = merchant.coupons.create(coupon_params)
      if new_coupon.save
        flash.now[:success] = 'Coupon added successfully'
      else
        flash.now[:error] = 'Coupon could not be added, please try again'
      end
    end
    @coupons = merchant.coupons

    render :index
  end

  def edit
    @coupon = Coupon.find(params[:id])
  end

  def update
    coupon = Coupon.find(params[:id])
    coupon.update(coupon_params)

    if coupon.save
      flash[:success] = 'Coupon updated successfully'
    else
      flash[:error] = 'Coupon not updated, please try again'
    end

    @coupons = current_user.merchant.coupons

    redirect_to "/merchant/coupons"
  end

  def destroy
    coupon = Coupon.find(params[:id])
    coupon.destroy

    flash[:danger] = 'Coupon deleted'
    @coupons = current_user.merchant.coupons

    redirect_back fallback_location: merchant_coupons_path
  end

  private
    def coupon_params
      params.permit :code, :name, :discount
    end
end
