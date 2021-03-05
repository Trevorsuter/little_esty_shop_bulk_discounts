class ChangePercentageInBulkDiscounts < ActiveRecord::Migration[5.2]
  def change
    change_column :bulk_discounts, :percentage, :decimal, precision: 10, scale: 2
  end
end
