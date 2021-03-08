class BulkDiscountsController < ApplicationController
  before_action :find_merchant, except: [:show, :new]
  before_action :find_bulk_discount, except: [:index, :new, :create]

  def index
    @discounts = @merchant.bulk_discounts
    @three_closest_holidays = HolidaySearch.new.three_closest_holidays
  end

  def show
  end

  def new
  end

  def create
    @bulk_discount = @merchant.bulk_discounts.new(new_bulk_discount_params)
    if @bulk_discount.save
      redirect_to merchant_bulk_discounts_path(@merchant)
    else
      flash[:notice] = "Bulk Discount not created: Required information missing."
      render :new
    end
  end

  def edit
  end

  def update
    if @discount.update(edit_bulk_discount_params)
      flash[:notice] = 'Bulk Discount Updated!'
      redirect_to merchant_bulk_discount_path(@merchant, @discount)
    else
      flash[:notice] = 'You messed up, hotshot... try again.'
      redirect_to edit_merchant_bulk_discount_path(@merchant, @discount)
    end
  end

  def destroy
    @discount.destroy
    redirect_to merchant_bulk_discounts_path(@merchant)
  end

  private
  def edit_bulk_discount_params
    params.require(:bulk_discount).permit(:description, :percentage, :threshold)
  end

  private
  def new_bulk_discount_params
    params.permit(:description, :percentage, :threshold)
  end

  private
  def find_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end

  private
  def find_bulk_discount
    @discount = BulkDiscount.find(params[:id])
  end
end