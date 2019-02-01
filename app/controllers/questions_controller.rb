class QuestionsController < ApplicationController
  before_action :question_params, only: :create
  load_and_authorize_resource

  # GET /questions
  # GET /
  def index
    params[:order] ||= 'updated_at DESC'
    params[:filter] ||= 'all'
    @questions = @questions.filter(query_params).paginate(page: params[:page])
    
    respond_to :html
  end

  # GET /questions/new
  def new
    respond_to :html
  end

  # GET /questions/:id/edit
  def edit
    respond_to :html
  end

  # POST /questions
  def create
    @question.user_id = current_user.id
    flash[:success] = 'Question posted successfully!' if @question.save

    respond_to do |format|
      if @question.persisted?
        format.html { redirect_to @question }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH /questions/:id
  def update
    if @question.update_attributes(question_params)
      flash[:success] = 'Question updated successfully!'
    end

    respond_to do |format|
      if @question.valid?
        format.html { redirect_to @question }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /questions/:id
  def destroy
    if @question.destroy
      flash[:success] = 'Question deleted successfully!'
      path_to_redirect = root_path
    else
      flash[:danger] = @question.errors.full_messages
      path_to_redirect = @question
    end

    respond_to do |format|
      format.html { redirect_to path_to_redirect }
    end
  end

  # GET questions/:id
  def show
    @comments = @question.comments
    @answers = @question.answers.includes(:comments)

    respond_to :html
  end

  # PATCH /questions/:id/upvote
  def update_vote
    if @question.votes.valid_vote_value?(params[:value])
      @question.votes.update_vote(@question, current_user.id, params[:value])
    end

    respond_to :js
  end

  private

  def question_params
    params[:question] = params.require(:question)
                              .permit(:title, :content, :tags)
  end

  def query_params
    params.permit(:filter, :page, :order, :search_content)
  end

  rescue_from ActiveRecord::RecordNotFound do
    flash[:danger] = "No question found for id #{params[:id]}"

    redirect_to questions_path
  end
end
