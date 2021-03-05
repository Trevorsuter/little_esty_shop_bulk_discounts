require 'rails_helper'

RSpec.describe BulkDiscount, type: :model do
  describe 'relationships' do
    it {should belong_to :merchant}
  end
  describe 'validations' do
    it {should validate_presence_of :percentage}
    it {should validate_presence_of :threshold}
    it {should validate_presence_of :description}
  end

  describe 'before save' do
    before :each do
      @merchant = Merchant.create(name: "Trevor Suter")
      @discount = @merchant.bulk_discounts.create(percentage: 20, threshold: 10, description: "discount")
    end
    it 'changes the full integer to a decimal' do
      expect(@discount.percentage.to_f).to_not eq(20.0)
      expect(@discount.percentage.to_f).to eq(0.2)
    end
  end
end