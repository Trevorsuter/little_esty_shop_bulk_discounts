class BulkDiscountsController < ApplicationController

  def index
    @merchant = Merchant.find(params[:merchant_id])
    @discounts = @merchant.bulk_discounts
    @three_closest_holidays = HolidaySearch.new.three_closest_holidays
  end

  def show
    @discount = BulkDiscount.find(params[:id])
  end
end