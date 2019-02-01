class Question < ActiveRecord::Base
  validates :content, presence: true, length: { maximum: 65_534 }
  validates :user, presence: true
  validates :title, presence: true, length: { maximum: 254 }

  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :votes, as: :votable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  delegate :name, :id, :email, to: :user, prefix: true

  scope :asked_last_week, -> { where('questions.created_at <= ?', 1.week.ago) }
  scope :answered, -> { joins(:answers) }
  scope :accepted, -> { joins(:answers).where(answers: { accepted: true }) }

  FILTER_COLLECTION = ['all', 'answered', 'un_answered', 'asked_last_week',
                       'accepted'].freeze
  ORDER_COLLECTION = ['updated_at ASC', 'updated_at DESC', 'total_votes ASC',
                      'total_votes  DESC', 'count(answers.question_id) ASC',
                      'count(answers.question_id) DESC'].freeze
  GROUP_BY_COLLECTION = ['count(answers.question_id) ASC',
                         'count(answers.question_id) DESC'].freeze

  def self.filter(options)
    require_join_status = false

    if FILTER_COLLECTION.include?(options[:filter])
      questions = send(options[:filter])
      if options[:filter] == 'asked_last_week' || options[:filter] == 'all'
        require_join_status = true
      end
    else
      questions = all
    end

    if options[:search_content].present? && require_join_status
      questions = questions.left_join
      require_join_status = false
    end

    if options[:search_content].present?
      questions = questions.search(options[:search_content])
    end

    if ORDER_COLLECTION.include?(options[:order])
      if GROUP_BY_COLLECTION.include?(options[:order])
        if require_join_status
          questions = questions.left_join
        end
        questions = questions.group(:id)
      end

      questions = questions.order(options[:order])
    end
    questions
  end

  def self.un_answered
    joins('LEFT JOIN answers ON questions.id = answers.question_id')
      .where(answers: { question_id: nil })
  end

  def self.search(search_content)
    where('questions.content LIKE :content OR title LIKE :content OR
          answers.content LIKE :content', content: "%#{search_content}%").uniq
  end

  def self.left_join
    joins('LEFT JOIN answers ON questions.id = answers.question_id')
  end

  def update_accept_status(answer)
    correct_answer = answers.correct_answer

    if answer.accepted? || correct_answer.blank?
      unless answer.update_attributes(accepted: !answer.accepted?)
        answer.errors.full_messages.each do |msg|
          errors.add(:base, msg)
        end
      end
    else
      errors.add(:base, 'Only one correct answer is allowed!')
    end
  end
end
