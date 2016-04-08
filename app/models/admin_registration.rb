class AdminRegistration
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming


  # Attributes
  attr_accessor :email
  attr_accessor :password
  attr_accessor :password_confirmation
  attr_accessor :registered_id


  # Validations
  validates :email, presence: true
  validates :password, presence: true, confirmation: true


  # Public: Initialize an AdminRegistration.
  #
  # attributes - Hash
  #   email - String the admin's email address.
  #   password - String the admin's unencrypted password.
  #   password_confirmation - String the admin's unencrypted password.
  def initialize(attributes = {})
    @email = attributes[:email]
    @password = attributes[:password]
    @password_confirmation = attributes[:password_confirmation]
  end

  def create!
    # Run the ActiveModel::Validations first.
    return false unless valid?

    # Try to create the admin.
    admin = Admin.create(email: email, password: password)
    if admin.valid?
      self.registered_id = admin.id
      return true
    else
      admin.errors.each { |key, value| self.errors[key] = value }
      return false
    end
  end

end
