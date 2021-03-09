require 'rails_helper'

RSpec.describe 'Bulk Discount Show Page', type: :feature do
  before :each do
    @merchant1 = Merchant.create!(name: 'Hair Care')
    @discount1 = @merchant1.bulk_discounts.create!(percentage: 20, threshold: 10, description: "discount 1")
    @discount2 = @merchant1.bulk_discounts.create!(percentage: 15, threshold: 15, description: "discount 2")

    visit merchant_bulk_discount_path(@merchant1, @discount1)
  end

  it 'shows the bulk discounts attributes' do

    expect(page).to have_content(@discount1.description)
    expect(page).to have_content(@discount1.percentage)
    expect(page).to have_content(@discount1.threshold)

  end

  it 'does not show attributes of other records' do
    
    expect(page).to_not have_content(@discount2.description)
    expect(page).to_not have_content(@discount2.percentage)
    expect(page).to_not have_content(@discount2.threshold)

  end

  it 'has a functional update button' do

    expect(page).to have_link('update')

    click_link 'update'

    expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant1, @discount1))

  end
end