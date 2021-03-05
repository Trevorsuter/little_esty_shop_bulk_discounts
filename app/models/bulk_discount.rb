class BulkDiscount < ApplicationRecord
  belongs_to :merchant
  validates_presence_of :percentage
  validates_presence_of :threshold
  validates_presence_of :description
  before_save :calculate_percentage

  def calculate_percentage
    self.percentage *= 0.01
  end
end