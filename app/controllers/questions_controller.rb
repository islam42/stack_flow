require "#{Rails.root}/events_machine/mail_event"
class QuestionsController < ApplicationController
  include EchoServer
  before_action :load_question, only: :create
  load_and_authorize_resource 
  
  # GET /questions
  # GET /
  def index
    @order = params[:order]
    @order ||= 'updated_at desc'
    if params[:order] == 'count(answers.id) asc' || params[:order] == 'count(answers.id) desc'
      @questions = @questions.questions_with_answered_sort(params[:order], params[:page])
    else
      @questions = @questions.order(@order).page(params[:page])
    end
    @filter = "questions"
    respond_to do |format|
      format.html { render :index }
    end
  end

  # GET /questions/new
  def new
    respond_to do |format|
      format.html { render :new }
    end
  end

  # GET /questions/:id/edit
  def edit
    respond_to do |format|
      format.html { render :edit }
    end
  end

  # POST /questions
  def create
    if @question.save
      flash[:success] = "question posted successfuly!"
      respond_to do |format|
        format.html { redirect_to @question }
      end
    else
      respond_to do |format|
        format.html { render :new }
      end
    end
  end

  # PUT /questions/:id
  # PATCH /questions/:id
  def update
    if @question.update_attributes(question_params)
      flash[:success] = "question updated successfuly!"
      respond_to do |format|
        format.html { redirect_to @question }
      end
    else
      respond_to do |format|
        format.html { render :new }
      end
    end

  end

  # DELETE /questions/:id
  def destroy
    if @question.destroy
      flash[:success] = "question successfuly deleted"
      path = root_path
    else
      flash[:danger] = "No question found!"
      path = request.referer
    end
    respond_to do |format|
      format.html { redirect_to path }
    end
  end

  # GET questions/:id
  def show
    @comments = @question.comments
    @answers = @question.answers.includes(:comments).all
    respond_to do |format|
      format.html
    end
  end

  # GET /questions/search
  def search
    @search_parameter = params[:content]
    if params[:content].blank?
      flash[:danger] = "Please type a valid string in search bar!"
      respond_to do |format|
        format.html {  redirect_to request.referer }
      end
      return
    end
    @order = params[:order]
    @questions = @questions.search(params[:content],params[:order],params[:page])
    respond_to do |format|
      format.html {  render :search }
    end
  end 

  # PUT /questions/:id/upvote
  def upvote
    vote = @question.votes.find_by(user_id: current_user.id, value: 1)
    if vote.nil?
      vote = @question.votes.build(user_id: current_user.id, value: 1)
      if vote.save
        @question.update_attribute('total_votes', @question.total_votes + 1)

        mail = { :from =>  'stackflow@gmail.com', :to => current_user.email, :subject => 'upvote for Question',
                 :body => "#{current_user.name} hit upvote your question '#{ @question.title }'" }
        generate_email(mail)
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
        mail = { :from =>  'stackflow@gmail.com', :to => current_user.email, :subject => 'Question downvote',
                 :body => "#{current_user.name} hit downvote your question '#{ @question.title }'" }
        generate_email(mail)
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
    @questions = @questions.answered(params[:order], params[:page])
    @order = params[:order]
    @filter = 'answered'
    respond_to do |format|
      format.html {  render :index }
    end
  end

  # GET /questions/asked_last_week
  def asked_last_week
   if params[:order] == 'count(answers.id) asc' || params[:order] == 'count(answers.id) desc'
    @questions = @questions.asked_last_week_with_answered_sort(params[:order], params[:page])
  else
    @questions = @questions.asked_last_week(params[:order], params[:page])
  end
  @filter = 'asked_last_week'
  @order = params[:order] 
  respond_to do |format|
    format.html {  render :index }
  end
end

  # GET /questions/un_answered
  def un_answered
    @questions = @questions.un_answered(params[:order], params[:page])
    @filter = 'un_answered'
    @order = params[:order]
    respond_to do |format|
      format.html {  render :index }
    end
  end

  # GET /questions/accepted
  def accepted
    @questions = @questions.accepted(params[:order], params[:page])
    @filter = 'accepted'
    @order = params[:order]
    respond_to do |format|
      format.html {  render :index }
    end
  end

  private
  def load_question
    @question = current_user.questions.build(question_params)
  end

  def question_params
    params.require(:question).permit(:title, :content, :tags)
  end

end
