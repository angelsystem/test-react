# Public: A collection of useful classes and methods to generate view and
# response logic for AdminRegistrations.
class AdminRegistrationsView

  # Public: Logic for admin_registrations#new
  class New

    # Attributes
    #
    # Public: Returns the AdminRegistration.
    attr_reader :admin_registration


    # Public: Initialize the admin_registrations#new view.
    #
    # admin_registration - An AdminRegistion that manages the registration
    # attempt.
    def initialize(admin_registration)
      @admin_registration = admin_registration
    end

    # Returns Boolean indicating whether there's an error on that +attribute+.
    def errors_on?(attribute)
      case attribute
      when :email, :password, :password_confirmation
        @admin_registration.errors[attribute].any?
      else
        raise "Error messages not implemented for \"#{attribute}\""
      end
    end

    # Returns String that informs the user of the error.
    def error_message_for(attribute)
      case attribute
      when :email, :password, :password_confirmation
        @admin_registration.errors[attribute].join(', ')
      else
        raise "Error messages not implmeneted for \"#{attribute}\""
      end
    end

  end

end
