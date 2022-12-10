class Transaction < ApplicationRecord
  attr_accessor :to_account_id

  belongs_to :account
  enum :kind, { 'deposit' => 0, 'withdraw' => 1 }

  validates :kind, inclusion: { in: %w[deposit withdraw] }
  validates :account, presence: true
  validates :value, presence: true, numericality: true
end
