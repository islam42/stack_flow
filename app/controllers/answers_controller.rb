class AnswersController < ApplicationController
  before_action :load_answer, only: :create
  load_and_authorize_resource

  # POST /questions/:question_id/answers
  def create
    @question = Question.find_by(id: params[:question_id])
    @answer.question_id = params[:question_id]
    @answer.user_id = params[:user_id]
    if @answer.save
      # QuestionActivityMailer.question_activity(current_user, @question, 'New Answer Posted').deliver_now
      flash[:success] = "answer successfull posted"
      redirect_to request.referer
    else
      @answers = @question.answers
      flash[:danger] = @answer.errors.full_messages
      redirect_to request.referer
    end
   # respond_to do |format|  
   #      format.js { render 'questions/show'}
   #  end  
 end

 # GET /questions/:question_id/answers/:id/edit
 def edit
 end

  # PUT /questions/:question_id/answers/:id
  # PATCH /questions/:question_id/answers/:id
 def update
  if @answer.update_attributes(answer_params)
    flash[:success] = "updated successfully"
    redirect_to :controller => 'questions', :action => 'show', :id => @answer.question_id
  else
    flash[:danger] = @answer.errors.full_messages
    redirect_to request.referer
  end
end

# DELETE /questions/:question_id/answers/:id
def destroy
  @answer
  @answer.destroy
  flash[:success] = "answer successfully deleted"
  redirect_to request.referer
end

# PUT /questions/:question_id/answers/:id/upvote
def upvote
  @answer
  @answer.update_attribute('votes', @answer.votes + 1)
  respond_to do |format|
    format.json { render json: @answer.votes }
  end
end

# PUT /questions/:question_id/answers/:id/downvote
def downvote
  @answer
  @answer.update_attribute('votes', @answer.votes - 1)
  respond_to do |format|
    format.json { render json: @answer.votes }
  end
end

# PUT /questions/:question_id/answers/:id/accept
def accept
  @answer
  if @answer.question.user_id == current_user.id
    answers = @answer.question.answers.where("question_id = #{@answer.question_id} && status = true").count
    if answers > 0
      flash[:danger] = "Question can have only one correct answer!"
      redirect_to request.referer
    else
      @answer.update_attribute(:status, true)
      respond_to do |format|
        format.json { render json: true }
      end
    end
  else
    flash[:danger] = "not Allowed"
    redirect_to request.referer
  end
end

# PUT /questions/:question_id/answers/:id/reject
def reject
  @answer
  if @answer.question.user_id == current_user.id
    if @answer.status
      @answer.update_attribute(:status, false)
      message = true
    else
      message = false
    end
    respond_to do |format|
      format.json { render json: message }
    end
  else
    flash[:danger] = "Not allowed!"
    redirect_to request.referer
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
