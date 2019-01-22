class Question < ActiveRecord::Base
  validates :content, presence: true, length: { maximum: 65_534 }
  validates :user, presence: true
  validates :title, presence: true, length: { maximum: 254 }

  belongs_to :user
  delegate :name, :id, :email, to: :user, prefix: true
  has_many :answers, dependent: :destroy
  has_many :votes, as: :votable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  def self.answered(params)
    joins(:answers).group('id').order(order_by_parameters(params[:order]))
                   .paginate(page: params[:page])
  end

  def self.all_questions(params)
    joins('left join answers on questions.id = answers.question_id')
      .group('id').order(order_by_parameters(params[:order]))
      .paginate(page: params[:page])
  end

  def self.un_answered(params)
    joins('left join answers on questions.id = answers.question_id')
      .group('id').select('answers.question_id', 'questions.*')
      .having('answers.question_id IS NULL')
      .order(order_by_parameters(params[:order])).paginate(page: params[:page])
  end

  def self.accepted(params)
    joins(:answers).select('questions.*', 'answers.status')
                   .group('id').having('answers.status = ?', true)
                   .order(order_by_parameters(params[:order]))
                   .paginate(page: params[:page])
  end

  def self.asked_last_week(params)
    joins('left join answers on questions.id = answers.question_id')
      .group('questions.id')
      .having('questions.created_at <= ?', 1.week.ago)
      .order(order_by_parameters(params[:order])).paginate(page: params[:page])
  end

  def self.search(params)
    joins('left join answers on questions.id = answers.question_id')
      .where('questions.content like :content or title like :content or
              answers.content like :content', content: "%#{params[:content]}%")
      .uniq.includes(:user).order(order_by_parameters(params[:order]))
      .paginate(page: params[:page])
  end

  def self.order_by_parameters(order)
    if ['updated_at asc', 'updated_at desc', 'total_votes asc',
        'total_votes desc', 'count(answers.question_id) asc',
        'count(answers.question_id) desc'].include?(order)
      order
    end
  end

  def tags_separator
    tags.split(',')
  end

  def upvote(user_id)
    votes.find_by(votable_type: 'Question', votable_id: id, value: 1,
                  user_id: user_id)
  end

  def downvote(user_id)
    votes.find_by(votable_type: 'Question', votable_id: id, value: -1,
                  user_id: user_id)
  end

  def add_upvote(user_id)
    vote = votes.build(user_id: user_id, value: 1)
    transaction do
      increment!(:total_votes)
      vote.save!
    end
  rescue ActiveRecord::RecordNotSaved
    errors.add(:question, 'invalid question object')
    false
  rescue ActiveRecord::RecordInvalid
    errors.add(:question, vote.errors.full_messages)
    false
  end

  def delete_upvote(vote)
    transaction do
      decrement!(:total_votes)
      vote.destroy!
    end
  rescue ActiveRecord::RecordNotSaved
    errors.add(:question, 'invalid question object')
    false
  rescue ActiveRecord::RecordNotDestroyed
    errors.add(:question, vote.errors.full_messages)
    false
  end

  def add_downvote(user_id)
    vote = votes.build(user_id: user_id, value: -1)
    transaction do
      decrement!(:total_votes)
      vote.save!
    end
  rescue ActiveRecord::RecordNotSaved
    errors.add(:question, 'invalid question object')
    false
  rescue ActiveRecord::RecordInvalid
    errors.add(:question, vote.errors.full_messages)
    false
  end

  def delete_downvote(vote)
    transaction do
      increment!(:total_votes)
      vote.destroy!
    end
  rescue ActiveRecord::RecordNotSaved
    errors.add(:question, 'invalid question object')
    false
  rescue ActiveRecord::RecordNotDestroyed
    errors.add(:question, vote.errors.full_messages)
    false
  end
end
