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
    flash[:comment_error] = @comment.errors.full_messages unless @comment.save

    respond_to { |format| format.js { render :comment_section } }
  end

  # GET /comments/:id/edit
  def edit
    @question_id = params[:question_id]
    respond_to :html
  end

  # PUT /comments/:id
  def update
    if @comment.update_attributes(comment_params)
    else
      flash[:update_comment_error] = @comment.errors.full_messages
    end
    respond_to { |format| format.js { render :update_comment } }
  end

  # DELETE /comments/:id
  def destroy
    flash[:comment_delete_error] = 'comment not deleted' unless @comment.destroy
    respond_to { |format| format.js { render :delete_comment } }
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
