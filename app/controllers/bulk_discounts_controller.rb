class BulkDiscountsController < ApplicationController

  def index
    @merchant = Merchant.find(params[:merchant_id])
    @discounts = @merchant.bulk_discounts
    @three_closest_holidays = HolidaySearch.new.three_closest_holidays
  end

  def show
    @discount = BulkDiscount.find(params[:id])
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    @merchant.bulk_discounts.create(
                                description: params[:description],
                                percentage: params[:percentage],
                                threshold: params[:threshold]
                                )
    
    redirect_to merchant_bulk_discounts_path(@merchant)
  end
end