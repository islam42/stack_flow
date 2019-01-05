class QuestionsController < ApplicationController
  before_action :load_question, only: :create
  load_and_authorize_resource 

  # GET /questions
  # GET /
  def index
    if params[:order]
      @order = params[:order]
    else
      @order = 'updated_at desc'
    end
    @filter = "questions"
    @questions = @questions.order(@order).page(params[:page])
    render 'index'
  end

  # GET /questions/new
  def new
    @question = current_user.questions.build
  end

  # GET /questions/:id/edit
  def edit
    @question
  end

  # POST /questions
  def create
    @question = current_user.questions.build(question_params)
    if @question.save
      flash[:success] = "posted successfuly!"
      redirect_to @question
    else
      render :new
    end
  end

  # PUT /questions/:id
  # PATCH /questions/:id
  def update
    @question = current_user.questions.find_by(id: params[:id])
    if @question.update_attributes(question_params)
      flash[:success] = "successfuly update!"
      redirect_to @question
    else
      render :new
    end
  end

  # DELETE /questions/:id
  def destroy
    current_user.questions.find(params[:id]).destroy
    flash.now[:success] = "successfuly deleted"
    @questions = current_user.questions.paginate(page: params[:page])
    render 'devise/home'
  end

  # GET questions/:id
  def show
    # @questions
    @answer = @question.answers.build
    @comment = Comment.new
    @answers = Answer.where("question_id = #{@question.id}")
    @comments = @question.comments
    @answer_comments = @question.answers.includes(:comments).all
    # debugger
  end

  # GET /questions/search
  def search
    @search_parameter = params[:content]
    @order = params[:order]
    @questions = Question.where("content like '%#{params[:content]}%' or title
     like '%#{params[:content]}%' or id IN (?)",
     Answer.where("content like '%#{params[:content]}%'").select(:question_id)).order(params[:order]).paginate(page: params[:page])
    render 'search'
  end

  # PUT /questions/:id/upvote
  def upvote
    vote = @question.votes.find_by(user_id: current_user.id, value: 1)
    if vote.nil?
      vote = @question.votes.build(user_id: current_user.id, value: 1)
      if vote.save
        @question.update_attribute('total_votes', @question.total_votes + 1)
      end
    else
      if vote.destroy
        @question.update_attribute('total_votes', @question.total_votes - 1)
      end
    end
    respond_to do |format|
      format.json { render json: @question.total_votes }
    end
  end

  # PUT /questions/:id/downvote
  def downvote
    vote = @question.votes.find_by(user_id: current_user.id, value: -1)
    if vote.nil?
      vote = @question.votes.build(user_id: current_user.id, value: -1)
      if vote.save
        @question.update_attribute('total_votes', @question.total_votes - 1)
      end
    else
      if vote.destroy
        @question.update_attribute('total_votes', @question.total_votes + 1)
      end
    end
    respond_to do |format|
      format.json { render json: @question.total_votes }
    end
  end

  # GET /questions/answered
  def answered
    @questions = Question.where("id IN (?)", Answer.pluck(:question_id)).order(params[:order]).paginate(page: params[:page])
    @filter = 'answered'
    @order = params[:order]
    render 'index'
  end

  # GET /questions/asked_last_week
  def asked_last_week
    @questions = Question.where('created_at <= ?', 1.week.ago).order(params[:order]).paginate(page: params[:page])
    @filter = 'asked_last_week'
    @order = params[:order]
    render 'index'
  end

  # GET /questions/un_answered
  def un_answered
    @questions = Question.where("id NOT IN (?)", Answer.pluck(:question_id)).order(params[:order]).paginate(page: params[:page])
    @filter = 'un_answered'
    @order = params[:order]
    render 'index'
  end

  # GET /questions/accepted
  def accepted
    @questions = Question.where('id IN (?)', Answer.where('status = ?', true).select(:question_id)).order(params[:order]).paginate(page: params[:page]) 
    @filter = 'accepted'
    @order = params[:order]
    render 'index'
  end

  private
  def load_question
    @question = current_user.questions.build(question_params)
  end

  def question_params
    params.require(:question).permit(:title, :content, :tags)
  end

end
