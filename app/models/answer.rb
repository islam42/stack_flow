class Answer < ActiveRecord::Base
  validates :content, presence: true, length: {maximum: 65534}
  validates :user_id, presence: true
  validates :question_id, presence: true

  
  belongs_to :question
  belongs_to :user
  # has_many    :votes, as: :votable, dependent: :destroy
  has_many   :comments, as: :commentable, dependent: :destroy

end
