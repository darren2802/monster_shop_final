class Coupon < ApplicationRecord
  validates_presence_of :name, :code, :discount
  validates_uniqueness_of :name, :code

  belongs_to :merchant
  has_many :item_orders

  def self.coupon_limit_met
    if all.count >= 5
      true
    else
      false
    end
  end
end
