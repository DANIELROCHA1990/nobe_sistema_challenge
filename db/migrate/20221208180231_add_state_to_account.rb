class AddStateToAccount < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts, :state, :boolean, default: true
  end
end
