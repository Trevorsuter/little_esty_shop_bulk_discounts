class BulkDiscountsController < ApplicationController

  def index
    @merchant = Merchant.find(params[:merchant_id])
    @discounts = @merchant.bulk_discounts
    @three_closest_holidays = HolidaySearch.new.three_closest_holidays
  end

  def show
    @discount = BulkDiscount.find(params[:id])
  end

  def new
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    bulk_discount = @merchant.bulk_discounts.new(bulk_discount_params)
    if bulk_discount.save
      redirect_to merchant_bulk_discounts_path(@merchant)
    else
      flash[:notice] = "Bulk Discount not created: Required information missing."
      render :new
    end
  end

  def edit
  end

  def destroy
    BulkDiscount.find(params[:id]).destroy
    redirect_to merchant_bulk_discounts_path
  end

  private
  def bulk_discount_params
    params.permit(:description, :percentage, :threshold)
  end
end