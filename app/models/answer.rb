class Answer < ActiveRecord::Base
  validates :content, presence: true, length: { maximum: 65_534 }
  validates :user, presence: true
  validates :question, presence: true

  belongs_to :question
  belongs_to :user
  has_many :votes, as: :votable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  delegate :name, :id, :email, to: :user, prefix: true

  scope :correct_answer, -> { where(accepted: true) }
end
