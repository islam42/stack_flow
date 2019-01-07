class AnswersController < ApplicationController
  before_action :load_answer, only: :create
  load_and_authorize_resource

  # POST /questions/:question_id/answers
  def create
    @question = current_user.questions.find_by(id: params[:question_id])
    @answer.question_id = params[:question_id]
    @answer.user_id = params[:user_id]
    if @answer.save
      # QuestionActivityMailer.question_activity(current_user, @question, 'New Answer Posted').deliver_now
      flash[:success] = "answer successfull posted"
    else
      flash[:danger] = @answer.errors.full_messages
    end
    respond_to do |format|  
      format.html { redirect_to request.referer }
    end  
  end

 # GET /questions/:question_id/answers/:id/edit
 def edit
  respond_to do |format|
    format.html { render :edit }
  end
end

  # PUT /questions/:question_id/answers/:id
  # PATCH /questions/:question_id/answers/:id
  def update
    if @answer.update_attributes(answer_params)
      flash[:success] = "updated successfully"
      respond_to do |format|
        format.html { redirect_to :controller => 'questions', :action => 'show', :id => @answer.question_id }
      end
    else
      flash[:danger] = @answer.errors.full_messages
      respond_to do |format|
        format.html { redirect_to request.referer }
      end
    end
  end

  # DELETE /questions/:question_id/answers/:id
  def destroy
    if @answer.destroy
      flash[:success] = "answer successfully deleted"
    else
      flash[:danger] = @answer.errors.full_messages
    end
    respond_to do |format|
      format.html { redirect_to request.referer }
    end
  end

  # PUT /questions/:question_id/answers/:id/upvote
  def upvote
    vote = @answer.votes.find_by(user_id: current_user.id, value: 1)
    if vote.nil?
      vote = @answer.votes.build(user_id: current_user.id, value: 1)
      if vote.save
        @answer.update_attribute('total_votes', @answer.total_votes + 1)
      end
    else
      if vote.destroy
        @answer.update_attribute('total_votes', @answer.total_votes - 1)
      end
    end
    respond_to do |format|
      format.json { render json: @answer.total_votes }
    end
  end

  # PUT /questions/:question_id/answers/:id/downvote
  def downvote
    vote = @answer.votes.find_by(user_id: current_user.id, value: -1)
    if vote.nil?
      vote = @answer.votes.build(user_id: current_user.id, value: -1)
      if vote.save
        @answer.update_attribute('total_votes', @answer.total_votes - 1)
      end
    else
      if vote.destroy
        @answer.update_attribute('total_votes', @answer.total_votes + 1)
      end
    end
    respond_to do |format|
      format.json { render json: @answer.total_votes }
    end
  end

# PUT /questions/:question_id/answers/:id/accept
def accept
  if @answer.question.user_id == current_user.id
    answers = @answer.question.answers.where("status = true").count
    if answers > 0
      flash[:danger] = "Question can have only one correct answer!"
    else
      if @answer.update_attribute(:status, true)
        message = true
      else
        message = false
      end
      respond_to do |format|
        format.json { render json: message }
      end
      return 
    end
  else
    flash[:danger] = "Not allowed"
  end
  respond_to do |format|
    format.html { redirect_to request.referer }
  end 
end

# PUT /questions/:question_id/answers/:id/reject
def reject
  if @answer.question.user_id == current_user.id
    if @answer.status
      if @answer.update_attribute(:status, false)
        message = true
      else
        message = false
      end
    else
      message = false
    end
    respond_to do |format|
      format.json { render json: message }
    end
    return
  else
    flash[:danger] = "Not allowed!"
  end
  respond_to do |format|
    format.html { redirect_to request.referer }
  end
end

private
def load_answer
  @answer = Answer.new(answer_params)    
end

def answer_params
  params.require(:answer).permit(:content, :question_id, :user_id)
end
end
