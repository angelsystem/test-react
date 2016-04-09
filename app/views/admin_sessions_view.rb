# Public: A collection of useful classes and methods to generate view and
# response logic for AdminSessions.
class AdminSessionsView

  # Public: Logic for admin_sessions#new
  class New

    # Attributes
    #
    # Public: Returns the AdminSession.
    attr_reader :admin_session


    # Public: Initialize the admin_sessions#new view.
    #
    # admin_session - An AdminSession that manages the authentication attempt.
    def initialize(admin_session)
      @admin_session = admin_session
    end

    # Returns Boolean indicating whether there's an error on that +attribute+.
    def errors_on?(attribute)
      case attribute
      when :email, :password
        @admin_session.errors[attribute].any?
      else
        raise "Error messages not implemented for \"#{attribute}\""
      end
    end

    # Returns String that informs the user of the error.
    def error_message_for(attribute)
      case attribute
      when :email, :password
        @admin_session.errors[attribute].join(', ')
      else
        raise "Error messages not implmeneted for \"#{attribute}\""
      end
    end

  end

end
