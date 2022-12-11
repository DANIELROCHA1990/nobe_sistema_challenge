class User < ApplicationRecord
  has_many :accounts

  validates :username, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
