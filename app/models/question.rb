class Question < ActiveRecord::Base
  validates :content, presence: true, length: { maximum: 65_534 }
  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 254 }

  belongs_to :user
  delegate :name, :id, to: :user, prefix: true
  has_many :answers, dependent: :destroy
  has_many :votes, as: :votable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  def self.answered(params)
    joins(:answers).group('id').order(order_by_parameters(params[:order]))
                   .paginate(page: params[:page])
  end

  def self.asked_last_week_with_answered_sort(params)
    joins('left join answers on questions.id = answers.question_id')
      .where('questions.created_at <= ?', 1.week.ago).group('id')
      .order(order_by_parameters(params[:order])).paginate(page: params[:page])
  end

  def self.questions_with_answered_sort(params)
    joins('left join answers on questions.id = answers.question_id')
      .group('id').order(order_by_parameters(params[:order]))
      .paginate(page: params[:page])
  end

  def self.un_answered(params)
    joins('left join answers on questions.id = answers.question_id')
      .where('answers.question_id IS ? ', nil).group('id')
      .order(order_by_parameters(params[:order])).paginate(page: params[:page])
  end

  def self.accepted(params)
    joins(:answers).where('answers.status = ?', true)
                   .order(order_by_parameters(params[:order]))
                   .group('id').paginate(page: params[:page])
  end

  def self.search(params)
    joins('left join answers on questions.id = answers.question_id')
      .where('questions.content like :content or title like :content or
        answers.content like :content', content: "%#{params[:content]}%")
      .uniq.includes(:user)
      .order(order_by_parameters(params[:order])).paginate(page: params[:page])
  end

  def self.asked_last_week(params)
    where('created_at <= ?', 1.week.ago)
      .order(order_by_parameters(params[:order]))
      .paginate(page: params[:page])
  end

  def self.all_questions(params)
    includes(:user).order(order_by_parameters(params[:order]))
                   .page(params[:page])
  end

  def self.order_by_parameters(order)
    if ['updated_at asc', 'updated_at desc', 'total_votes asc',
        'total_votes desc', 'count(answers.id) asc',
        'count(answers.id) desc'].include?(order)
      order
    end
  end

  def tags_separator
    tags.split(',')
  end

  def upvote
    votes.find_by(votable_type: 'Question', votable_id: id, value: 1)
  end

  def downvote
    votes.find_by(votable_type: 'Question', votable_id: id, value: -1)
  end

  def add_upvote(user_id)
    vote = votes.build(user_id: user_id, value: 1)
    transaction do
      increment!(:total_votes)
      vote.save!
    end
  end

  def delete_upvote(vote)
    transaction do
      decrement!(:total_votes)
      vote.destroy!
    end
  end

  def add_downvote(user_id)
    vote = votes.build(user_id: user_id, value: -1)
    transaction do
      decrement!(:total_votes)
      vote.save!
    end
  end

  def delete_downvote(vote)
    transaction do
      increment!(:total_votes)
      vote.destroy!
    end
  end
end
