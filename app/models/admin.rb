class Admin < ActiveRecord::Base

  # Validations
  validates :email, presence: true, uniqueness: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }
  validates :password_digest, presence: true


  # Public: Encrypts the password into the +password_digest+ attribute, only if
  # the new password is not empty.
  #
  # Examples:
  #
  #   user = User.new
  #   user.password = nil
  #   user.password_digest # => nil
  #   user.password = 'mUc3m00RsqyRe'
  #   user.password_digest # => "$2a$10$4LEA7r4YmNHtvlAvHhsYAeZmk/..."
  def password=(unencrypted_password)
    if unencrypted_password.nil?
      self.password_digest = nil
    elsif !unencrypted_password.empty?
      @password = unencrypted_password
      self.password_digest = BCrypt::Password.create(unencrypted_password)
    end
  end

end
