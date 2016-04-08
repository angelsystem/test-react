class AdminRegistrationsController < ApplicationController

  # Filters
  before_filter :require_no_admin


  # GET /register
  def new
    @admin_registration = AdminRegistration.new
  end

  # POST /register
  def create
    @admin_registration = AdminRegistration.new(admin_registration_params)

    if @admin_registration.create!
      session[:admin_id] = @admin_registration.registered_id
      redirect_to root_path
    else
      render :new
    end
  end


  private

  # Internal: Allowed AdminRegistration params.
  def admin_registration_params
    params.require(:admin_registration).permit(
      :email,
      :password,
      :password_confirmation
    )
  end

end
