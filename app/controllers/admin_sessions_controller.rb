class AdminSessionsController < ApplicationController

  # Filters
  before_filter :require_no_admin, only: [:new, :create]


  # GET /sign_in
  def new
    @admin_session = AdminSession.new
  end

  # POST /sign_in
  def create

    @admin_session = AdminSession.new(admin_session_params)

    if @admin_session.authenticate!
      session[:admin_id] = @admin_session.authenticated_id
      redirect_to root_url
    else
      render :new
    end
  end

  # GET /sign_out
  def destroy
    session[:admin_id] = nil
    redirect_to sign_in_url
  end


  private

  # Internal: Allowed AdminSession params.
  def admin_session_params
    params.require(:admin_session).permit(
      :email,
      :password
    )
  end

end
