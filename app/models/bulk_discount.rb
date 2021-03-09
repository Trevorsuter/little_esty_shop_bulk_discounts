class BulkDiscount < ApplicationRecord
  belongs_to :merchant
  has_many :items, through: :merchant
  has_many :invoice_items, through: :items
  validates_presence_of :percentage
  validates_presence_of :threshold
  validates_presence_of :description
end