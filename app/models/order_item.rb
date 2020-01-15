class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :item
  belongs_to :coupon, optional: true

  def subtotal
    quantity * price / 100
  end

  def discount
    subtotal * coupon.discount / 100
  end

  def discounted_subtotal
    if coupon
      subtotal - discount
    else
      subtotal
    end
  end

  def fulfill
    update(fulfilled: true)
    item.update(inventory: item.inventory - quantity)
  end

  def fulfillable?
    item.inventory >= quantity
  end
end
