require 'rails_helper'

RSpec.describe 'Bulk Discounts New Page', type: :feature do
  before :each do
    @merchant1 = Merchant.create!(name: 'Hair Care')

    visit new_merchant_bulk_discount_path(@merchant1)
  end

  it 'sees the right fields for a new bulk discount' do

    expect(page).to have_field('description')
    expect(page).to have_field('percentage')
    expect(page).to have_field('threshold')

  end

  it 'has a create button' do

    expect(page).to have_button('create')

  end

  it 'can create a new bulk discount' do

    fill_in 'description', with: 'bulk discount 1 created!'
    fill_in 'percentage', with: '20'
    fill_in 'threshold', with: '15'

    click_button 'create'

    expect(current_path).to eq(merchant_bulk_discounts_path(@merchant1))

    expect(page).to have_content('bulk discount 1 created!')
    expect(page).to have_content('20')
    expect(page).to have_content('15')
    
  end

  it 'cannot create a new bulk discount without filling in all the forms'

  it 'cannot create a new bulk discount if a field has an incorrect data type'
end