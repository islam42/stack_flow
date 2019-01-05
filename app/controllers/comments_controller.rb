class CommentsController < ApplicationController

# POST /questions/:question_id/comments
# POST /questions/:question_id/answers/:answer_id/comments
  def create
    @comment = current_user.comments.build(comment_params)
    @comment.commentable_id = params[:commentable_id]
    @comment.commentable_type = params[:commentable_type]
    if @comment.save
      flash[:success] = "successfully posted"
      redirect_to request.referer
    else
      @question = Question.find(params[:question_id])
      flash[:danger] = "Not saved "
      render 'questions/show'
    end
  end

  private 
  def comment_params
    params.require(:comment).permit(:body, :commentable_id, :commentable_type)
  end
end

