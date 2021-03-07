require 'rails_helper'

RSpec.describe 'merchant bulk discounts index', type: :feature do
  before :each do
    @merchant1 = Merchant.create!(name: 'Hair Care')
    @merchant2 = Merchant.create!(name: 'Nail Care')

    @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
    @customer_2 = Customer.create!(first_name: 'Cecilia', last_name: 'Jones')
    @customer_3 = Customer.create!(first_name: 'Mariah', last_name: 'Carrey')
    @customer_4 = Customer.create!(first_name: 'Leigh Ann', last_name: 'Bron')
    @customer_5 = Customer.create!(first_name: 'Sylvester', last_name: 'Nader')
    @customer_6 = Customer.create!(first_name: 'Herber', last_name: 'Coon')

    @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2)
    @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2)
    @invoice_3 = Invoice.create!(customer_id: @customer_2.id, status: 2)
    @invoice_4 = Invoice.create!(customer_id: @customer_3.id, status: 2)
    @invoice_5 = Invoice.create!(customer_id: @customer_4.id, status: 2)
    @invoice_6 = Invoice.create!(customer_id: @customer_5.id, status: 2)
    @invoice_7 = Invoice.create!(customer_id: @customer_6.id, status: 1)

    @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id)
    @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @merchant1.id)
    @item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: @merchant1.id)
    @item_4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: @merchant1.id)

    @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 0)
    @ii_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 1, unit_price: 8, status: 0)
    @ii_3 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_3.id, quantity: 1, unit_price: 5, status: 2)
    @ii_4 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)

    @transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_1.id)
    @transaction2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: @invoice_3.id)
    @transaction3 = Transaction.create!(credit_card_number: 234092, result: 1, invoice_id: @invoice_4.id)
    @transaction4 = Transaction.create!(credit_card_number: 230429, result: 1, invoice_id: @invoice_5.id)
    @transaction5 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: @invoice_6.id)
    @transaction6 = Transaction.create!(credit_card_number: 879799, result: 1, invoice_id: @invoice_7.id)
    @transaction7 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_2.id)

    @discount1 = @merchant1.bulk_discounts.create!(percentage: 20, threshold: 10, description: "discount 1")
    @discount2 = @merchant1.bulk_discounts.create!(percentage: 15, threshold: 5, description: "discount 2")
    @discount3 = @merchant1.bulk_discounts.create!(percentage: 30, threshold: 20, description: "discount 3")
    @discount4 = @merchant1.bulk_discounts.create!(percentage: 25, threshold: 15, description: "discount 4")
    @discount5 = @merchant2.bulk_discounts.create!(percentage: 25, threshold: 15, description: "discount 5")

    visit merchant_bulk_discounts_path(@merchant1)
  end

  it 'shows all of the merchants bulk discounts' do

    within('#discounts') do
      expect(page).to have_content(@discount1.id)
      expect(page).to have_content(@discount2.id)
      expect(page).to have_content(@discount3.id)
      expect(page).to have_content(@discount4.id)
    end

  end

  it 'does not show bulk discounts from other merchants' do
    expect(page).to_not have_content(@discount5.id)
  end

  it 'has the name and date of the next 3 upcoming us holidays' do
    holidays = HolidaySearch.new.holidays
    holiday1 = holidays[0]
    holiday2 = holidays[1]
    holiday3 = holidays[2]

    within("#holiday-header") do
      expect(page).to have_content("Upcoming Holidays")
    end

    within("##{holiday1.date}") do
      expect(page).to have_content(holiday1.name)
      expect(page).to have_content(holiday1.date)
    end
    within("##{holiday2.date}") do
      expect(page).to have_content(holiday2.name)
      expect(page).to have_content(holiday2.date)
    end
    within("##{holiday3.date}") do
      expect(page).to have_content(holiday3.name)
      expect(page).to have_content(holiday3.date)
    end

  end

  it 'has a link to create a new bulk discount' do

    expect(page).to have_link("Create")

    click_link "Create"
    expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant1))

  end

  describe 'each bulk discount' do

    it 'shows its percentage' do

      within("#discount-#{@discount1.id}") do
        expect(page).to have_content(@discount1.percentage)
      end
      within("#discount-#{@discount2.id}") do
        expect(page).to have_content(@discount2.percentage)
      end
      within("#discount-#{@discount3.id}") do
        expect(page).to have_content(@discount3.percentage)
      end
      within("#discount-#{@discount4.id}") do
        expect(page).to have_content(@discount4.percentage)
      end
    end
    it 'shows its quantity threshold' do

      within("#discount-#{@discount1.id}") do
        expect(page).to have_content(@discount1.threshold)
      end
      within("#discount-#{@discount2.id}") do
        expect(page).to have_content(@discount2.threshold)
      end
      within("#discount-#{@discount3.id}") do
        expect(page).to have_content(@discount3.threshold)
      end
      within("#discount-#{@discount4.id}") do
        expect(page).to have_content(@discount4.threshold)
      end
    end
    it 'shows its description' do

      within("#discount-#{@discount1.id}") do
        expect(page).to have_content(@discount1.description)
      end
      within("#discount-#{@discount2.id}") do
        expect(page).to have_content(@discount2.description)
      end
      within("#discount-#{@discount3.id}") do
        expect(page).to have_content(@discount3.description)
      end
      within("#discount-#{@discount4.id}") do
        expect(page).to have_content(@discount4.description)
      end
    end
    it 'has a link to its show page' do
      within("#discount-#{@discount1.id}") do
        expect(page).to have_link("#{@discount1.id}", href: merchant_bulk_discount_path(@merchant1.id, @discount1.id))
      end
      within("#discount-#{@discount2.id}") do
        expect(page).to have_link("#{@discount2.id}", href: merchant_bulk_discount_path(@merchant1.id, @discount2.id))
      end
      within("#discount-#{@discount3.id}") do
        expect(page).to have_link("#{@discount3.id}", href: merchant_bulk_discount_path(@merchant1.id, @discount3.id))
      end
      within("#discount-#{@discount4.id}") do
        expect(page).to have_link("#{@discount4.id}", href: merchant_bulk_discount_path(@merchant1.id, @discount4.id))
      end  
    end

    it 'directs to the discounts show page when its link is clicked' do

      click_link "#{@discount1.id}"
      
      expect(current_path).to eq("/merchant/#{@merchant1.id}/bulk_discounts/#{@discount1.id}")
    end
  end
end