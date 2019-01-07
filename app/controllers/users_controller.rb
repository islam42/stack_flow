class UsersController < ApplicationController
  load_and_authorize_resource

  # GET /users
  def index
   @users = @users.page(params[:page])
   respond_to do |format|
    format.html
  end
end

  # GET /users/:id
  def show
    @questions = @user.questions.order('total_votes DESC').limit(5)
    @answers = @user.answers.order('total_votes DESC').limit(5)
    respond_to do |format|
      format.html
    end
  end

# PUT /users/:id/activate_deactivate
def activate_deactivate
  update_status = false;
  if !@user.admin?
    if @user.toggle!(:status)
      update_status = true
    end
  end
  respond_to do |format|
    format.json { render json: update_status }
  end
end

end
