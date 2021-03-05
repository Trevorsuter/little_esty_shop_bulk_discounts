class BulkDiscount < ApplicationRecord
  belongs_to :merchant
  validates_presence_of :percentage
  validates_presence_of :threshold
  validates_presence_of :description
end