class Question < ActiveRecord::Base
  validates   :content, presence: true, length: {maximum: 65534}
  validates   :user_id, presence: true
  validates   :title, presence:true, length: {maximum: 254}

  belongs_to  :user
  has_many    :answers, dependent: :destroy
  has_many     :votes, as: :votable, dependent: :destroy
  has_many    :comments, as: :commentable, dependent: :destroy

  scope :answered_sort, ->(order, page) { joins(:answers).group('id').order(order).paginate(page: page) }
  scope :answered ,     ->(order, page) { where("id IN (?)", Answer.pluck(:question_id)).order(order).paginate(page: page) }
  scope :asked_last_week, ->(order, page) { where('created_at <= ?', 1.week.ago).order(order).paginate(page: page) }
  scope :un_answered, ->(order, page) { where("id NOT IN (?)", Answer.pluck(:question_id)).order(order).paginate(page: page) }
  scope :accepted, ->(order, page) { where('id IN (?)', Answer.where('status = ?', true).select(:question_id)).order(order).paginate(page: page)  }
  scope :search,    ->(content, order, page) { where("content like ? or title like ? or id IN (?)", "%#{content}%", "%#{content}%",
                                                Answer.where("content like ? ", "%#{content}%").select(:question_id)).order(order).paginate(page: page) }

  def tags_separator
    tags.split(',')
  end
end
