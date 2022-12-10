class User < ApplicationRecord
  has_many :accounts

  validates :username, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  # validates :password, length: { minimum: 6 }, unless: -> { password.present? } 

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
