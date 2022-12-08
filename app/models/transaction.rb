class Transaction < ApplicationRecord
  belongs_to :account

  enum :kind, { 'deposit' => 0, 'withdraw' => 1 }
end
