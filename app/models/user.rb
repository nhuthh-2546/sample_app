class User < ApplicationRecord
  before_save{email.downcase!}

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze

  validates :name, presence: true, length: {maximum: Settings.user.max_name}
  validates :email, presence: true, length: {maximum: Settings.user.max_email},
                    format: {with: VALID_EMAIL_REGEX},
                    uniqueness: true
  validates :password, presence: true, length: {minimum: Settings.user.min_password}
  has_secure_password
end
