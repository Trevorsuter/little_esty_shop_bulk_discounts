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

  it 'fields are prefilled with the original values' do
    
    expect(page).to have_field('bulk_discount[description]', with: "#{@discount1.description}")
    expect(page).to have_field('bulk_discount[percentage]', with: "#{@discount1.percentage}")
    expect(page).to have_field('bulk_discount[threshold]', with: "#{@discount1.threshold}")

  end
  
  it 'can update a bulk discount' do

    fill_in 'bulk_discount[description]', with: 'Update Complete!'
    fill_in 'bulk_discount[percentage]', with: '50'
    fill_in 'bulk_discount[threshold]', with: '75'
    click_button 'submit'

    expect(current_path).to eq(merchant_bulk_discount_path(@merchant1, @discount1))
    expect(page).to have_content('Bulk Discount Updated!')
    expect(page).to have_content('Update Complete!')
    expect(page).to have_content('50')
    expect(page).to have_content('75')

    expect(page).to_not have_content('discount 1')
    expect(page).to_not have_content('20')
    expect(page).to_not have_content('10')
  end

  it 'cannot update without filling out all fields' do
    fill_in 'bulk_discount[description]', with: ''
    fill_in 'bulk_discount[percentage]', with: ''
    fill_in 'bulk_discount[threshold]', with: ''
    click_button 'submit'

    expect(page).to have_content('You messed up, hotshot... try again.')
    expect(page).to have_field('bulk_discount[description]', with: "#{@discount1.description}")
    expect(page).to have_field('bulk_discount[percentage]', with: "#{@discount1.percentage}")
    expect(page).to have_field('bulk_discount[threshold]', with: "#{@discount1.threshold}")
  end
end