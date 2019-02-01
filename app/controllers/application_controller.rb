class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
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

  # rescue_from Exception do
  #   flash[:danger] = "Something went wrong. Try again!"

  #   redirect_to questions_path
  # end

  rescue_from CanCan::AccessDenied do
    flash[:danger] = 'You are not authorized to access this resource!'

    redirect_to questions_path
  end

  def routing_error
    @error = 'Page not found!'
    @msg = "We're sorry, we couldn't find the page you requested.!"

    render 'shared/error_page', status: 404
  end
end
