class CommentsController < ApplicationController
  before_action :require_login, only: :create
  load_resource :question, if: -> { params[:question_id].present? },
                           only: :create
  load_resource :answer, if: -> { params[:answer_id].present? },
                         only: :create
  before_action :load_comment, only: :create
  load_and_authorize_resource

  # POST /questions/:question_id/comments
  # POST /questions/:question_id/answers/:answer_id/comments
  def create
    @comment.user_id = current_user.id
    if @comment.save
      flash[:success] = 'comment successfully posted'
    else
      flash[:danger] = @comment.errors.full_messages
    end
    respond_to do |format|
      format.html { redirect_to request.referer }
    end
  end

  # GET /comments/:id/edit
  def edit
    @question_id = params[:question_id]
    respond_to :html
  end

  # PUT /comments/:id
  def update
    if @comment.update_attributes(comment_params)
      flash[:success] = 'comment updated successfully'
      respond_to do |format|
        format.html do
          redirect_to controller: 'questions', action: 'show',
                      id: params[:question_id]
        end
      end
    else
      flash[:danger] = @comment.errors.full_messages
      respond_to do |format|
        format.html { redirect_to request.referer }
      end
    end
  end

  # DELETE /comments/:id
  def destroy
    if @comment.destroy
      flash[:success] = 'comment successfully deleted'
    else
      flash[:danger] = 'comment not deleted'
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

  def commentable
    @question || @answer
  end

  def load_comment
    @comment = commentable.comments.build(comment_params)
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
