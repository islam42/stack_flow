class QuestionsController < ApplicationController
  before_action :require_login, only: :create
  before_action :load_question, only: :create
  load_and_authorize_resource

  # GET /questions
  # GET /
  def index
    @order = params[:order]
    @order ||= 'updated_at desc'

    @questions = if params[:order] == 'count(answers.id) asc' ||
                    params[:order] == 'count(answers.id) desc'
                   @questions.questions_with_answered_sort(query_params)
                 else
                   @questions.all_questions(query_params)
                 end
    @filter = 'questions'
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
      path = root_path
    else
      flash[:danger] = 'No question found!'
      path = request.referer
    end
    respond_to { |format| format.html { redirect_to path } }
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
    @search_parameter = params[:content]
    if params[:content].blank?
      flash[:danger] = 'Please type a valid string to search!'
      respond_to { |format| format.html { redirect_to request.referer } }
      return
    end
    @order = params[:order]
    @questions = @questions.search(query_params)
    respond_to { |format| format.html { render :search } }
  end

  # PUT /questions/:id/upvote
  def upvote
    vote = @question.upvote
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
        flash.now[:upvote_error] = 'Not downvoted. See log file!'
      end
    else
      unless @question.delete_upvote(vote)
        flash.now[:upvote_error] = 'Not downvoted. See log file!'
      end
    end
    respond_to { |format| format.js { render :upvote } }
  end

  # PUT /questions/:id/downvote
  def downvote
    vote = @question.downvote
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
        flash.now[:downvote_error] = 'Not downvoted. See log file!'
      end
    else
      unless @question.delete_downvote(vote)
        flash.now[:downvote_error] = 'Not downvoted. See log file!'
      end
    end
    respond_to { |format| format.js { render :downvote } }
  end

  # GET /questions/answered
  def answered
    @questions = @questions.answered(query_params)
    @order = params[:order]
    @filter = 'answered'
    respond_to { |format| format.html { render :index } }
  end

  # GET /questions/asked_last_week
  def asked_last_week
    @questions = if params[:order] == 'count(answers.id) asc' ||
                    params[:order] == 'count(answers.id) desc'
                   @questions.asked_last_week_with_answered_sort(query_params)
                 else
                   @questions.asked_last_week(query_params)
                 end
    @filter = 'asked_last_week'
    @order = params[:order]
    respond_to { |format| format.html { render :index } }
  end

  # GET /questions/un_answered
  def un_answered
    @questions = @questions.un_answered(query_params)
    @filter = 'un_answered'
    @order = params[:order]
    respond_to { |format| format.html { render :index } }
  end

  # GET /questions/accepted
  def accepted
    @questions = @questions.accepted(query_params)
    @filter = 'accepted'
    @order = params[:order]
    respond_to { |format| format.html { render :index } }
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

  def query_params
    params.permit(:filter, :page, :content, :order)
  end
end
