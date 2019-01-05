class UsersController < ApplicationController
  load_and_authorize_resource

  # GET /users
  def index
   @users = @users.page(params[:page])
  end

  # GET /users/:id
  def show
    @user
    @questions = @user.questions.order('votes DESC').limit(5)
    @answers = @user.answers.order('votes DESC').limit(5)
  end

# PUT /users/:id/activate_deactivate
  def activate_deactivate
    @user
    status_changed = false;
    if current_user.admin?
      if @user.admin?
        status_changed = false;
      else
        @user.toggle!(:status)
        status_changed = true
      end
    end
    respond_to do |format|
      format.json { render json: status_changed }
    end
  end

end
