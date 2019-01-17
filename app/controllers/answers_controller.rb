class AnswersController < ApplicationController
  before_action :require_login, only: :create
  load_resource :question, only: :create
  before_action :load_answer, only: :create
  load_and_authorize_resource

  # POST /questions/:question_id/answers
  def create
    @answer.user_id = current_user.id
    if @answer.save
      flash[:success] = 'answer successfull posted'
      Thread.new do
        QuestionActivityMailer.question_activity(current_user,
                                                 @answer.question,
                                                 'New Answer Created',
                                                 'has posted new answer for')
                              .deliver_later
      end
    else
      flash[:danger] = @answer.errors.full_messages
    end
    respond_to do |format|
      format.html { redirect_to request.referer }
    end
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
      Thread.new do
        QuestionActivityMailer.question_activity(current_user,
                                                 @answer.question,
                                                 'Answer Updated',
                                                 'has updated answer for')
                              .deliver_later
      end
      respond_to do |format|
        format.html do
          redirect_to controller: 'questions',
                      action: 'show', id: @answer.question_id
        end
      end
    else
      flash[:danger] = @answer.errors.full_messages
      respond_to do |format|
        format.html { redirect_to request.referer }
      end
    end
  end

  # DELETE /answers/:id
  def destroy
    if @answer.destroy
      flash[:success] = 'answer successfully deleted'
      Thread.new do
        QuestionActivityMailer.question_activity(current_user,
                                                 @answer.question,
                                                 'Answer deleted',
                                                 'has deleted an answer for')
                              .deliver_later
      end
    else
      flash[:danger] = @answer.errors.full_messages
    end
    respond_to do |format|
      format.html { redirect_to request.referer }
    end
  end

  # PUT /questions/:question_id/answers/:id/upvote
  def upvote
    status = 304
    vote = @answer.upvote
    if vote.nil?
      status = 201 if @answer.add_upvote(current_user.id)
    else
      status = 200 if @answer.delete_upvote(vote)
    end
    respond_to do |format|
      format.json { render json: { votes: @answer.total_votes,
                                   status: status } }
    end
  end

  # PUT /questions/:question_id/answers/:id/downvote
  def downvote
    status = 304
    vote = @answer.downvote
    if vote.nil?
      status = 201 if @answer.add_downvote(current_user.id)
    else
      status = 200 if @answer.delete_downvote(vote)
    end
    respond_to do |format|
      format.json { render json: { votes: @answer.total_votes,
                                   status: status } }
    end
  end

  # PUT /questions/:question_id/answers/:id/accept
  def accept
    message = false
    if auther?(@answer.question.user)
      answers = @answer.question.answers.where('status = ? ', true).count
      if answers > 0
        flash[:danger] = 'Question can have only one correct answer!'
      else
        message = true if @answer.update_attribute(:status, true)
        respond_to do |format|
          format.json { render json: message }
        end
        return
      end
    else
      flash[:danger] = 'Access denied'
    end
    respond_to do |format|
      format.html { redirect_to request.referer }
    end
  end

  # PUT /questions/:question_id/answers/:id/reject
  def reject
    message = false
    if auther?(@answer.question.user)
      if @answer.status
        message = true if @answer.update_attribute(:status, false)
      end
      respond_to do |format|
        format.json { render json: message }
      end
      return
    else
      flash[:danger] = 'Access denied!'
    end
    respond_to do |format|
      format.html { redirect_to request.referer }
    end
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
