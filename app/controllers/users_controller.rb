class UsersController < ApplicationController
  load_and_authorize_resource

  # GET /users
  def index
    @users = @users.page(params[:page])
    respond_to :html
  end

  # GET /users/:id
  def show
    @questions = @user.questions.order('total_votes DESC').limit(5)
    @answers = @user.answers.order('total_votes DESC').limit(5)
    respond_to :html
  end

  # PUT /users/:id/activate_deactivate
  def activate_deactivate
    update_status = false
    unless @user.admin?
      update_status = true if @user.toggle!(:status)
    end
    respond_to do |format|
      format.json { render json: update_status }
    end
  end

  # Delete /users/:id
  def destroy
    if !@user.admin?
      if @user.destroy
        flash[:success] = 'user successfull deleted'
      else
        flash[:danger] = 'No user found!'
      end
    else
      flash[:danger] = "Administrator can't be deleted!"
    end
    respond_to do |format|
      format.html { redirect_to request.referer }
    end
  end
end
