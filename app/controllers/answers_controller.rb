class AnswersController < ApplicationController
  before_action :require_login, only: :create
  load_resource :question, only: :create
  before_action :load_answer, only: :create
  load_and_authorize_resource

  # POST /questions/:question_id/answers
  def create
    @answer.user_id = current_user.id
    if @answer.save
      # Thread.new do
      #   QuestionActivityMailer.question_activity(current_user,
      #                                            @answer.question,
      #                                            'New Answer Created',
      #                                            'has posted new answer for')
      #                         .deliver_later
      # end
    else
      flash.now[:answer_error] = @answer.errors.full_messages
    end
    respond_to { |format| format.js { render :answer_section } }
  end

  # GET /answers/:id/edit
  def edit
    respond_to :html
  end

  # PUT /answers/:id
  # PATCH /answers/:id
  def update
    if @answer.update_attributes(answer_params)
      flash[:success] = 'answer updated successfully'
      # Thread.new do
      #   QuestionActivityMailer.question_activity(current_user,
      #                                            @answer.question,
      #                                            'Answer Updated',
      #                                            'has updated answer for')
      #                         .deliver_later
      # end
      respond_to do |format|
        format.html do
          redirect_to controller: 'questions',
                      action: 'show', id: @answer.question_id
        end
      end
    else
      respond_to { |format| format.html { render :edit } }
    end
  end

  # DELETE /answers/:id
  def destroy
    if @answer.destroy
      flash[:success] = 'answer successfully deleted'
      # Thread.new do
      #   QuestionActivityMailer.question_activity(current_user,
      #                                            @answer.question,
      #                                            'Answer deleted',
      #                                            'has deleted an answer for')
      #                         .deliver_later
      # end
    else
      flash[:danger] = @answer.errors.full_messages
    end
    respond_to { |format| format.html { redirect_to request.referer } }
  end

  # PUT /answers/:id/upvote
  def upvote
    vote = @answer.upvote
    if vote.nil?
      unless @answer.add_upvote(current_user.id)
        flash.now[:upvote_error] = 'Not upvoted. See log file!'
      end
    else
      unless @answer.delete_upvote(vote)
        flash.now[:upvote_error] = 'Not upvoted. See log file!'
      end
    end
    respond_to { |format| format.js { render :upvote } }
  end

  # PUT /answers/:id/downvote
  def downvote
    vote = @answer.downvote
    if vote.nil?
      unless @answer.add_downvote(current_user.id)
        flash.now[:downvote_error] = 'Not downvoted. See log file!'
      end
    else
      unless @answer.delete_downvote(vote)
        flash.now[:downvote_error] = 'Not downvoted. See log file!'
      end
    end
    respond_to { |format| format.js { render :downvote } }
  end

  # PUT /answers/:id/change_correct_status
  def change_correct_status
    if auther?(@answer.question.user) || current_user.admin?
      answers = @answer.question.answers.correct_answers
      if answers.zero? || @answer.status == true
        unless @answer.toggle!(:status)
          flash.now[:correct_status_error] = @answer.errors.full_messages
        end
      else
        flash.now[:correct_status_error] = 'only one correct answer possible!'
      end
    else
      flash.now[:correct_status_error] = 'Access denied'
    end
    respond_to { |format| format.js { render :correct_answer } }
  end

  private

  def require_login
    return if current_user

    flash[:danger] = 'please login to continue'
    redirect_to new_user_session_url
  end

  def load_answer
    @answer = @question.answers.build(answer_params)
  end

  def answer_params
    params.require(:answer).permit(:content, :question_id, :user_id)
  end
end
