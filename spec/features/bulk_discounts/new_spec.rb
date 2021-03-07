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

  it 'description must be filled in to create the bulk discount' do

    fill_in 'percentage', with: '20'
    fill_in 'threshold', with: '10'
    click_button 'create'

    expect(page).to have_content('Bulk Discount not created: Required information missing.')
    expect(page).to have_field('description')
    expect(page).to have_field('percentage')
    expect(page).to have_field('threshold')
    expect(page).to have_button('create')

  end

  it 'percentage must be filled in to create the bulk discount' do

    fill_in 'description', with: 'Cant Create'
    fill_in 'threshold', with: '10'
    click_button 'create'

    expect(page).to have_content('Bulk Discount not created: Required information missing.')
    expect(page).to have_field('description')
    expect(page).to have_field('percentage')
    expect(page).to have_field('threshold')
    expect(page).to have_button('create')

  end

  it 'threshold must be filled in to create the bulk discount' do

    fill_in 'percentage', with: '20'
    fill_in 'description', with: 'Cannot Create'
    click_button 'create'

    expect(page).to have_content('Bulk Discount not created: Required information missing.')
    expect(page).to have_field('description')
    expect(page).to have_field('percentage')
    expect(page).to have_field('threshold')
    expect(page).to have_button('create')
  end

end