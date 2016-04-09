class ApplicationController < ActionController::Base

  # CSRF protection
  protect_from_forgery with: :exception


  # View helpers
  helper_method :current_admin


  private

  def current_admin
    @current_admin ||= begin
      Admin.find_by(id: session[:admin_id]) if session[:admin_id]
    end
  end

  def require_admin
    redirect_to sign_in_url unless current_admin
  end

  def require_no_admin
    redirect_to root_url if current_admin
  end

end
