require 'rails_helper'

RSpec.describe 'Bulk discount Edit Page', type: :feature do
  before :each do
    @merchant1 = Merchant.create!(name: 'Hair Care')
    @discount1 = @merchant1.bulk_discounts.create!(percentage: 20, threshold: 10, description: "discount 1")
    @discount2 = @merchant1.bulk_discounts.create!(percentage: 15, threshold: 15, description: "discount 2")

    visit edit_merchant_bulk_discount_path(@merchant1, @discount1)
  end

  it 'has all the right forms and buttons' do

    expect(page).to have_field('bulk_discount[description]')
    expect(page).to have_field('bulk_discount[percentage]')
    expect(page).to have_field('bulk_discount[threshold]')
    expect(page).to have_button('submit')

  end

  it 'fields are prefilled with the original values'
  
  it 'can update a bulk discount'
end