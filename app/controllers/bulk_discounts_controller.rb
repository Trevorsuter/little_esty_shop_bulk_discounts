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
    bulk_discount = @merchant.bulk_discounts.new(new_bulk_discount_params)
    if bulk_discount.save
      redirect_to merchant_bulk_discounts_path(@merchant)
    else
      flash[:notice] = "Bulk Discount not created: Required information missing."
      render :new
    end
  end

  def edit
    @discount = BulkDiscount.find(params[:id])
    @merchant = Merchant.find(params[:merchant_id])
  end

  def update
    @discount = BulkDiscount.find(params[:id])
    @merchant = Merchant.find(params[:merchant_id])
    if @discount.update(edit_bulk_discount_params)
      flash[:notice] = 'Bulk Discount Updated!'
      redirect_to merchant_bulk_discount_path(@merchant, @discount)
    else
      flash[:notice] = 'You messed up, hotshot... try again.'
      redirect_to edit_merchant_bulk_discount_path(@merchant, @discount)
    end
  end

  def destroy
    BulkDiscount.find(params[:id]).destroy
    redirect_to merchant_bulk_discounts_path
  end

  private
  def edit_bulk_discount_params
    params.require(:bulk_discount).permit(:description, :percentage, :threshold)
  end

  private
  def new_bulk_discount_params
    params.permit(:description, :percentage, :threshold)
  end
end