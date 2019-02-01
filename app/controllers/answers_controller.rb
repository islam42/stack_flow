class AnswersController < ApplicationController
  load_and_authorize_resource :question, only: :create
  before_action :answer_params, only: :create
  load_and_authorize_resource :answer, through: :question, shallow: true

  # POST /questions/:question_id/answers
  def create
    @answer.user_id = current_user.id
    @answer.save

    respond_to :js
  end

  # GET /answers/:id/edit
  def edit
    respond_to :html
  end

  # PATCH /answers/:id
  def update
    if @answer.update_attributes(answer_params)
      flash[:success] = 'Answer updated successfully!' 
    end

    respond_to do |format|
      if @answer.valid?
        format.html { redirect_to @answer.question }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /answers/:id
  def destroy
    if @answer.destroy
      flash[:success] = 'Answer successfully deleted!'
    else
      flash[:danger] = @answer.errors.full_messages
    end

    respond_to do |format|
      format.html { redirect_to @answer.question }
    end
  end

  # PATCH /answers/:id/upvote
  def update_vote
    if @answer.votes.valid_vote_value?(params[:value])
      @answer.votes.update_vote(@answer, current_user.id, params[:value])
    end

    respond_to :js
  end

  # PATCH /answers/:id/change_correct_status
  def update_accept_status
    @question = @answer.question
    @question.update_accept_status(@answer)

    respond_to :js
  end

  private

  def answer_params
    params[:answer] = params.require(:answer)
                            .permit(:content, :activated)
  end

  rescue_from ActiveRecord::RecordNotFound do
    flash[:danger] = "No answer found for id #{params[:id]}"

    redirect_to questions_path
  end
end
