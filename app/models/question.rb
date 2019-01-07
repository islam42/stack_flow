class Question < ActiveRecord::Base
  validates   :content, presence: true, length: { maximum: 65534 }
  validates   :user_id, presence: true
  validates   :title, presence:true, length: { maximum: 254 }

  belongs_to  :user
  has_many    :answers, dependent: :destroy
  has_many     :votes, as: :votable, dependent: :destroy
  has_many    :comments, as: :commentable, dependent: :destroy

  scope :asked_last_week_with_answered_sort, ->(order, page) { joins('left join answers on questions.id = answers.question_id').where('questions.created_at <= ?', 1.week.ago).group('id').order(order).paginate(page: page) }
  scope :questions_with_answered_sort, ->(order, page) { joins('left join answers on questions.id = answers.question_id').group('id').order(order).paginate(page: page) }
  scope :answered ,     ->(order, page) { joins(:answers).group('id').order(order).paginate(page: page) }
  scope :asked_last_week, ->(order, page) { where('created_at <= ?', 1.week.ago).order(order).paginate(page: page) }
  scope :un_answered, ->(order, page) { joins('left join answers on questions.id = answers.question_id').where('answers.question_id IS NULL ').group('id').order(order).paginate(page: page) }
  scope :accepted, ->(order, page) { joins(:answers).where('answers.status = ?', true).group('id').order(order).paginate(page: page)  }
  scope :search,    ->(content, order, page) { joins(:answers).where("questions.content like ? or title like ? or answers.content like ? ", "%#{content}%", "%#{content}%", "%#{content}%").group('questions.id').order(order).paginate(page: page) }
                                                

  def tags_separator
    tags.split(',')
  end
end
