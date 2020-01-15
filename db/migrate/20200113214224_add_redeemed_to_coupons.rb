class AddRedeemedToCoupons < ActiveRecord::Migration[5.1]
  def change
    add_column :coupons, :redeemed, :boolean, default: :false
  end
end
