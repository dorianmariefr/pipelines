class User < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_secure_password

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
end
