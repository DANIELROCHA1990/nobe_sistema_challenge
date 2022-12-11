class RemoveBooleanToAccounts < ActiveRecord::Migration[7.0]
  def change
    remove_column :accounts, :boolean
  end
end
