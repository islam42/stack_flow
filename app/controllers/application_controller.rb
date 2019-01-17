class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include ApplicationHelper
  protect_from_forgery with: :exception
  before_action :configure_sign_up_params, if: :devise_controller?
  before_action :configure_account_update_params,
                only: [:update], if: :devise_controller?

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  rescue_from CanCan::AccessDenied do
    flash[:danger] = 'please login to continue'
    redirect_to new_user_session_url
  end

  rescue_from ActiveRecord::RecordNotFound do
    @error = 'Record Not found!'
    @msg = 'Record not exits possibily deleted or unactivated!'
    render 'shared/error_page', status: 404
  end

  # rescue_from ActiveRecord::StatementInvalid do
  #   flash[:danger] = 'please provide a valid parameters!'
  #   redirect_to root_path
  # end

  # rescue_from NoMethodError do
  #   @error = 'Invalid method called!'
  #   @msg = 'Please contact admin or check log file!'
  #   render 'shared/error_page', status: 404
  # end

  def routing_error
    @error = 'Page not found!'
    @msg = "We're sorry, we couldn't find the page you requested.!"
    render 'shared/error_page', status: 404
  end
end
