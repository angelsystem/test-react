class AdminSession
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming


  # Attributes
  attr_accessor :email
  attr_accessor :password
  attr_accessor :authenticated_id


  # Validations
  validates :email, presence: true
  validates :password, presence: true


  # Public: Initialize an AdminSession.
  #
  # attributes - Hash
  #   email - String to find the admin that's trying to auth.
  #   password - String the admin's unencrypted password.
  def initialize(attributes = {})
    @email = attributes[:email]
    @password = attributes[:password]
  end

  # Public: Authenticates credentials by +username_or_email+ and plaintext
  # +password+.
  #
  # If valid, sets the +authenticated_id+ to the accredited user. If
  # invalid, adds errors to the problem attribute.
  #
  # Returns Boolean representing whether the user authenticated successfully.
  def authenticate!
    # Run the ActiveModel::Validations first.
    return false unless valid?

    # Check to see if the email provided belongs to a user.
    errors.add(:email, :invalid) and return false unless admin

    # Does the unencrypted password match the admin's crypted one?
    if BCrypt::Password.new(admin.password_digest) == password
      self.authenticated_id = admin.id
      return true
    else
      errors.add(:password, :invalid)
      return false
    end
  end

  private

  # Internal: +admin+ who is trying to +authenticate!+.
  #
  # Returns Admin or nil.
  def admin
    @admin ||= Admin.find_by(email: email)
  end

end
