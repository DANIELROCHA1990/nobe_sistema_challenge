class AddValueToTransaction < ActiveRecord::Migration[7.0]
  def change
    add_column :transactions, :value, :decimal
  end
end
