class BulkDiscountsController < ApplicationController
  before_action :three_closest_holidays, only: [:index]

  def index
    @merchant = Merchant.find(params[:merchant_id])
    @discounts = @merchant.bulk_discounts
  end

  def show
    @discount = BulkDiscount.find(params[:id])
  end
end