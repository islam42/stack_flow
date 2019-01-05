class Question < ActiveRecord::Base
  validates   :content, presence: true, length: {maximum: 65534}
  validates   :user_id, presence: true
  validates   :title, presence:true, length: {maximum: 254}

  belongs_to  :user
  has_many    :answers, dependent: :destroy
  # has_many     :votes, as: :votable, dependent: :destroy
  has_many    :comments, as: :commentable, dependent: :destroy

# model name will ne be used
  # def answer_feed
  #   answers.where('question_id = ?', self.id)
  # end

  def tags_separator
    tags.split(',')
  end

end
