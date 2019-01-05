class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :name, presence: true

  has_many :questions,  dependent: :destroy
  has_many :answers,    dependent: :destroy
  has_many  :comments,  dependent: :destroy
  has_many  :votes,  dependent: :destroy

  def question_upvote(questions_id)
    self.votes.find_by(votable_type: 'Question', votable_id: questions_id, value: 1)
  end

  def question_downvote(questions_id)
    self.votes.find_by(votable_type: 'Question', votable_id: questions_id, value: -1)
  end

  def answer_upvote(answer_id)
    self.votes.find_by(votable_type: 'Answer', votable_id: answer_id, value: 1)
  end

  def answer_downvote(answer_id)
    self.votes.find_by(votable_type: 'Answer', votable_id: answer_id, value: -1)
  end


end
