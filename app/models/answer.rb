class Answer < ActiveRecord::Base
  validates :content, presence: true, length: { maximum: 65_534 }
  validates :user, presence: true
  validates :question, presence: true

  belongs_to :question
  belongs_to :user
  delegate :name, :id, to: :user, prefix: true
  has_many :votes, as: :votable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  def upvote(user_id)
    votes.find_by(votable_type: 'Answer', votable_id: id, value: 1,
                  user_id: user_id)
  end

  def downvote(user_id)
    votes.find_by(votable_type: 'Answer', votable_id: id, value: -1,
                  user_id: user_id)
  end

  def self.correct_answers
    where('status = ? ', true).count
  end

  def add_upvote(user_id)
    vote = votes.build(user_id: user_id, value: 1)
    transaction do
      increment!(:total_votes)
      vote.save!
    end
  rescue ActiveRecord::RecordNotSaved
    errors.add(:answer, 'invalid answer object')
    false
  rescue ActiveRecord::RecordInvalid
    errors.add(:answer, vote.errors.full_messages)
    false
  end

  def delete_upvote(vote)
    transaction do
      decrement!(:total_votes)
      vote.destroy!
    end
  rescue ActiveRecord::RecordNotSaved
    errors.add(:answer, 'invalid answer object')
    false
  rescue ActiveRecord::RecordNotDestroyed
    errors.add(:answer, vote.errors.full_messages)
    false
  end

  def add_downvote(user_id)
    vote = votes.build(user_id: user_id, value: -1)
    transaction do
      decrement!(:total_votes)
      vote.save!
    end
  rescue ActiveRecord::RecordNotSaved
    errors.add(:answer, 'invalid answer object')
    false
  rescue ActiveRecord::RecordInvalid
    errors.add(:answer, vote.errors.full_messages)
    false
  end

  def delete_downvote(vote)
    transaction do
      increment!(:total_votes)
      vote.destroy!
    end
  rescue ActiveRecord::RecordNotSaved
    errors.add(:answer, 'invalid answer object')
    false
  rescue ActiveRecord::RecordNotDestroyed
    errors.add(:answer, vote.errors.full_messages)
    false
  end
end
