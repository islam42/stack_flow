class Answer < ActiveRecord::Base
  validates :content, presence: true, length: { maximum: 65_534 }
  validates :user_id, presence: true
  validates :question_id, presence: true

  belongs_to :question
  belongs_to :user
  delegate :name, :id, to: :user, prefix: true
  has_many :votes, as: :votable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  def upvote
    votes.find_by(votable_type: 'Answer', votable_id: id, value: 1)
  end

  def downvote
    votes.find_by(votable_type: 'Answer', votable_id: id, value: -1)
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
