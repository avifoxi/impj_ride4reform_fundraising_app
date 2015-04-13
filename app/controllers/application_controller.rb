class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # list admin authenticate first 
  before_action :authenticate_admin!, :authenticate_user!


  before_action :configure_permitted_parameters, if: :devise_controller?

  # def ensure_admin_or_user
  #   unless current_admin || current_user
  #     :authenticate_admin!
  #     :authenticate_user!
  #   end
  # end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:title, :first_name, :last_name, :email, :password, :password_confirmation) }
  end

end
