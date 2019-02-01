class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :name, presence: true, length: { minimum: 3 }

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :votes, dependent: :destroy

  TOP_MAX_RECORDS = 5

  def top_questions
    questions.order('total_votes DESC').limit(TOP_MAX_RECORDS)
  end

  def top_answers
    answers.order('total_votes DESC').limit(TOP_MAX_RECORDS)
  end

  def update_active_status
    update_attributes(:activated, !activated?)
  end

  def auther?(authorizable)
    self == authorizable.user
  end
end
