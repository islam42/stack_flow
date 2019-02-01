class CommentsController < ApplicationController
  load_resource :question, if: -> { params[:question_id].present? }
  load_resource :answer, if: -> { params[:answer_id].present? }
  before_action :comment_params, only: :create
  load_and_authorize_resource through: [:question, :answer], shallow: true

  # POST /questions/:question_id/comments
  # POST /answers/:answer_id/comments
  def create
    @comment.user_id = current_user.id
    @comment.save

    respond_to :js
  end

  # GET /comments/:id/edit
  def edit
    respond_to :html
  end

  # PATCH /comments/:id
  def update
    @comment.update_attributes(comment_params)

    respond_to :js
  end

  # DELETE /comments/:id
  def destroy
    flash[:danger] = @comment.errors.full_messages unless @comment.destroy

    respond_to :js
  end

  private

  def comment_params
    params[:comment] = params.require(:comment).permit(:body)
  end

  rescue_from ActiveRecord::RecordNotFound do
    flash[:danger] = "No comment found for id #{params[:id]}"

    redirect_to questions_path
  end
end
