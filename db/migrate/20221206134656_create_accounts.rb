class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts do |t|
      t.timestamps
    end
    add_reference :accounts, :user, foreign_key: true
  end
end
