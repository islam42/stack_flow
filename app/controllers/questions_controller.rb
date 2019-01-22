class QuestionsController < ApplicationController
  before_action :require_login, only: :create
  before_action :load_question, only: :create
  load_and_authorize_resource

  # GET /questions
  # GET /
  def index
    @order = 'updated_at desc'
    @filter = 'all'
    @questions = @questions.all_questions(query_params)
    respond_to do |format|
      format.html { render :index }
      format.json { render :index }
    end
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
    if @question.save
      flash[:success] = 'question posted successfuly!'
      respond_to { |format| format.html { redirect_to @question } }
    else
      respond_to { |format| format.html { render :new } }
    end
  end

  # PUT /questions/:id
  # PATCH /questions/:id
  def update
    if @question.update_attributes(question_params)
      flash[:success] = 'question updated successfuly!'
      respond_to { |format| format.html { redirect_to @question } }
    else
      respond_to { |format| format.html { render :new } }
    end
  end

  # DELETE /questions/:id
  def destroy
    if @question.destroy
      flash[:success] = 'question successfuly deleted'
      path_to_redirect = root_path
    else
      flash[:danger] = @question.errors.full_messages
      path_to_redirect = request.referer
    end
    respond_to { |format| format.html { redirect_to path_to_redirect } }
  end

  # GET questions/:id
  def show
    @comments = @question.comments
    @answers = @question.answers.includes(:comments).all
    respond_to do |format|
      format.html { render :show }
      format.json { render @question }
    end
  end

  # GET /questions/search
  def search
    @search_parameter = search_params[:content]
    if @search_parameter.blank?
      flash[:danger] = 'Please type a valid string to search!'
      respond_to { |format| format.html { redirect_to root_path } }
    else
      @order = search_params[:order]
      @questions = @questions.search(search_params)
      respond_to { |format| format.html { render :search } }
    end
  end

  # PUT /questions/:id/upvote
  def upvote
    vote = @question.upvote(current_user.id)
    if vote.nil?
      if @question.add_upvote(current_user.id)
        # Thread.new do
        #   QuestionActivityMailer.question_activity(current_user,
        #                                            @question,
        #                                            'Question Upvoted',
        #                                            'has upvoted')
        #                         .deliver_later
        # end
      else
        flash.now[:upvote_error] = @question.errors.messages[:question]
      end
    else
      unless @question.delete_upvote(vote)
        flash.now[:upvote_error] = @question.errors.messages[:question]
      end
    end
    respond_to { |format| format.js { render :upvote } }
  end

  # PUT /questions/:id/downvote
  def downvote
    vote = @question.downvote(current_user.id)
    if vote.nil?
      if @question.add_downvote(current_user.id)
        # Thread.new do
        #   QuestionActivityMailer.question_activity(current_user,
        #                                            @question,
        #                                            'Question Downvoted',
        #                                            'has downvoted')
        #                         .deliver_later
        # end
      else
        flash.now[:downvote_error] = @question.errors.messages[:question]
      end
    else
      unless @question.delete_downvote(vote)
        flash.now[:downvote_error] = @question.errors.messages[:question]
      end
    end
    respond_to { |format| format.js { render :downvote } }
  end

  # GET /questions/filtered_questions
  def filtered_questions
    @filter = filter_params(params[:filter])
    if @filter.nil?
      flash[:danger] = 'invalid filter specified'
      respond_to { |format| format.html { redirect_to root_path } }
    else
      @questions = if @filter == 'all'
                     @questions.all_questions(query_params)
                   elsif @filter == 'answered'
                     @questions.answered(query_params)
                   elsif @filter == 'asked_last_week'
                     @questions.asked_last_week(query_params)
                   elsif @filter == 'un_answered'
                     @questions.un_answered(query_params)
                   elsif @filter == 'accepted'
                     @questions.accepted(query_params)
                   end
      @order = params[:order]
      respond_to { |format| format.html { render :index } }
    end
  end

  private

  def load_question
    @question = current_user.questions.build(question_params)
  end

  def require_login
    return if current_user

    flash[:danger] = 'please login to continue'
    redirect_to new_user_session_url
  end

  def question_params
    params.require(:question).permit(:title, :content, :tags)
  end

  def filter_params(filter)
    filter if %w[answered un_answered asked_last_week
                 accepted all].include?(filter)
  end

  def search_params
    params.permit(:content, :order)
  end

  def query_params
    params.permit(:filter, :page, :order)
  end

  rescue_from ActiveRecord::RecordNotFound do
    flash[:danger] = "No question found for id #{params[:id]}"
    redirect_to root_path
  end
end
