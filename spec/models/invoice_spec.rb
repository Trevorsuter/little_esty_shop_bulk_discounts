require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe "validations" do
    it { should validate_presence_of :status }
    it { should validate_presence_of :customer_id }
  end
  describe "relationships" do
    it { should belong_to :customer }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
    it { should have_many :transactions}
  end
  describe "instance methods" do
    before :each do
      @merchant1 = Merchant.create!(name: 'Hair Care')
      @merchant2 = Merchant.create!(name: 'Hair Care')

      @item_1 = @merchant1.items.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, status: 1)
      @item_2 = @merchant1.items.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, status: 1)
      @item_3 = @merchant1.items.create!(name: "Body Wash", description: "This washes your body", unit_price: 20, status: 1)
      @item_4 = @merchant1.items.create!(name: "Hair Tie", description: "This holds up your hair in a tie", unit_price: 5, status: 1)
      @item_5 = @merchant2.items.create!(name: "Hockey Stick", description: "This is a Hockey Stick", unit_price: 50, status: 1)
      @item_6 = @merchant2.items.create!(name: "Hockey Puck", description: "This is a Hockey Puck", unit_price: 10, status: 1)
      @item_7 = @merchant2.items.create!(name: "Hockey Helmet", description: "This is a Hockey Helmet", unit_price: 100, status: 1)
      @item_8 = @merchant2.items.create!(name: "Hockey Tape", description: "This is a roll of Hockey Tape", unit_price: 5, status: 1)

      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      @customer_2 = Customer.create!(first_name: 'Trevor', last_name: 'Suter')

      @invoice_1 = @customer_1.invoices.create!(status: 2, created_at: "2012-03-27 14:54:09")
      @invoice_2 = @customer_1.invoices.create!(status: 2, created_at: "2012-03-27 14:54:09")
      @invoice_3 = @customer_2.invoices.create!(status: 2, created_at: "2012-03-27 14:54:09")
      @invoice_4 = @customer_1.invoices.create!(status: 2, created_at: "2012-03-27 14:54:09")

      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
      @ii_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 1, unit_price: 10, status: 1)
      @ii_3 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_1.id, quantity: 10, unit_price: 10, status: 2)
      @ii_4 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_2.id, quantity: 5, unit_price: 5, status: 2)
      @ii_5 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_3.id, quantity: 15, unit_price: 20, status: 2)
      @ii_6 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_4.id, quantity: 20, unit_price: 5, status: 2)
      @ii_7 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_1.id, quantity: 10, unit_price: 10, status: 2)
      @ii_8 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_2.id, quantity: 10, unit_price: 5, status: 2)
      @ii_9 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_7.id, quantity: 5, unit_price: 20, status: 2)
      @ii_10 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_8.id, quantity: 15, unit_price: 5, status: 2)
      @ii_11 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_5.id, quantity: 2, unit_price: 50, status: 2)
      @ii_12 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_6.id, quantity: 10, unit_price: 10, status: 2)
      @ii_13 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_7.id, quantity: 10, unit_price: 90, status: 2)
      @ii_14 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_8.id, quantity: 1, unit_price: 10, status: 2)

      @discount1 = @merchant1.bulk_discounts.create!(description: "bulk discount 1", percentage: 25, threshold: 20)
      @discount2 = @merchant1.bulk_discounts.create!(description: "bulk discount 2", percentage: 20, threshold: 10)
      @discount3 = @merchant1.bulk_discounts.create!(description: "bulk discount 3", percentage: 10, threshold: 5)
    end
    it "total_revenue" do

      expect(@invoice_1.total_revenue).to eq(100)
    end

    it 'can find the total revenue with discounts applied' do

      expect(@invoice_1.total_discount).to eq(9.0)
      expect(@invoice_2.total_discount).to eq(107.5)
      expect(@invoice_3.total_discount).to eq(30)
      expect(@invoice_4.total_discount).to eq(0)
    end

    it 'can find its invoice items with discounts' do

      inv1_expected = [@ii_1]
      inv2_expected = [@ii_3, @ii_4, @ii_5, @ii_6]
      inv3_expected = [@ii_7, @ii_8]

      expect(@invoice_1.invoice_items_with_discounts.uniq.sort).to eq(inv1_expected.sort)
      expect(@invoice_2.invoice_items_with_discounts.uniq.sort).to eq(inv2_expected.sort)
      expect(@invoice_3.invoice_items_with_discounts.uniq.sort).to eq(inv3_expected.sort)
      expect(@invoice_4.invoice_items_with_discounts).to eq([])
    end

    it 'can find the total amount of discount' do
      
      expected_1 = @invoice_1.total_revenue - @invoice_1.total_discount 
      expected_2 = @invoice_2.total_revenue - @invoice_2.total_discount 
      expected_3 = @invoice_3.total_revenue - @invoice_3.total_discount 
      expected_4 = @invoice_4.total_revenue 

      expect(@invoice_1.total_discounted_revenue).to eq(expected_1)
      expect(@invoice_2.total_discounted_revenue).to eq(expected_2)
      expect(@invoice_3.total_discounted_revenue).to eq(expected_3)
      expect(@invoice_4.total_discounted_revenue).to eq (expected_4)
    end

    it 'can find the discount applied for each invoice_item' do

      expect(@invoice_1.discount_for_invoice_item(@ii_1.id)).to eq(@discount3.id)
      expect(@invoice_1.discount_for_invoice_item(@ii_2.id)).to be_nil

      expect(@invoice_2.discount_for_invoice_item(@ii_3.id)).to eq(@discount2.id)
      expect(@invoice_2.discount_for_invoice_item(@ii_4.id)).to eq(@discount3.id)
      expect(@invoice_2.discount_for_invoice_item(@ii_5.id)).to eq(@discount2.id)
      expect(@invoice_2.discount_for_invoice_item(@ii_6.id)).to eq(@discount1.id)

      expect(@invoice_3.discount_for_invoice_item(@ii_7.id)).to eq(@discount2.id)
      expect(@invoice_3.discount_for_invoice_item(@ii_8.id)).to eq(@discount2.id)
      expect(@invoice_3.discount_for_invoice_item(@ii_9.id)).to be_nil
      expect(@invoice_3.discount_for_invoice_item(@ii_10.id)).to be_nil

      expect(@invoice_4.discount_for_invoice_item(@ii_11.id)).to be_nil
      expect(@invoice_4.discount_for_invoice_item(@ii_12.id)).to be_nil
      expect(@invoice_4.discount_for_invoice_item(@ii_13.id)).to be_nil
      expect(@invoice_4.discount_for_invoice_item(@ii_14.id)).to be_nil
    end
  end
end
