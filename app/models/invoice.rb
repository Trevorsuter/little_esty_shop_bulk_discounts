class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :customer_id

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items

  enum status: [:cancelled, :in_progress, :complete]

  def gross_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def total_revenue
    gross_revenue - total_discount
  end

  def invoice_items_with_discounts
    invoice_items.joins(:bulk_discounts)
    .where('bulk_discounts.threshold <= invoice_items.quantity')
    .select('invoice_items.*, max(percentage) as max_discount, bulk_discounts.id as discount_id')
    .group(:id, 'bulk_discounts.id')
  end

  def total_discount
    invoice_items_with_discounts.uniq.sum do |invoice_item|
      invoice_item.quantity * (invoice_item.unit_price * (invoice_item.max_discount * 0.01))
    end
  end

  def discount_for_invoice_item(ii_id)
    bd = invoice_items_with_discounts.where(id: ii_id).first
    bd.discount_id if bd != nil
  end
end
