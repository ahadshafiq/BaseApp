class User < ActiveRecord::Base
  attr_accessible  :name, :email, :password, :password_confirmation
  has_secure_password
  # This solves the problem of case insensitivity in the database emal uniqueness field
  # This starts here
  before_save { |user| user.email= user.email.downcase }
  # All the emails in teh database will get forced downcased
  # This ends here
  validates :name, presence: true, length: {maximum: 50} #nested hash needs curly braces
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format:  { with: VALID_EMAIL_REGEX},
  					uniqueness: { case_sensitive: false}
  validates :password, length: {minimum: 6}
  validates :password_confirmation, presence: true
end
