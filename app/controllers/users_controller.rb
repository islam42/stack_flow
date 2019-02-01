class UsersController < ApplicationController
  load_and_authorize_resource

  # GET /users
  def index
    @users = @users.paginate(page: params[:page])

    respond_to :html
  end

  # GET /users/:id
  def show
    @questions = @user.top_questions
    @answers = @user.top_answers

    respond_to :html
  end

  # PATCH /users/:id
  def update
    @user.update_active_status

    respond_to :js
  end

  # DELETE /users/:id
  def destroy
    if @user.destroy
      flash[:success] = 'User deleted successfully!'
    else
      flash[:danger] = @user.errors.full_messages
    end

    respond_to do |format|
      format.html { redirect_to users_path }
    end
  end

  rescue_from ActiveRecord::RecordNotFound do
    flash[:danger] = "No user found for id #{params[:id]}"

    redirect_to questions_path
  end
end
