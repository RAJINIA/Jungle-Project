class User < ActiveRecord::Base
  has_secure_password
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 3 }
  validates :password_confirmation, presence: true

  before_save :email_caseless

  def email_caseless
    self.email.downcase! 
  end

  #method to authenticate, takes params from sessions controller
  def self.authenticate_with_credentials(email, password)
    #Find user by email
    user = User.find_by_email(email.downcase.strip)
    #if exists and has_secure_password, return user.
    if user && user.authenticate(password)
      user
    else
      nil
    end
  end
end