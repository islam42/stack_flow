# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    super
  end

  # POST /resource/sign_in
  def create
    user = User.find_by(email: params[:user][:email])
    if !user.nil?
      if user.status
        super
        return
      else
        flash[:danger] = "You are not allowed to login.Please contact Admin."
      end
    else
      flash[:danger] = "Invalid Email Address"
    end
    respond_to do |format|
      format.html {  redirect_to request.referer }
    end
  end

  # DELETE /resource/sign_out
  def destroy
    super
  end



  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
