class Vote < ActiveRecord::Base
  validates :user, presence: true
  validates :votable, presence: true
  validates :value, presence: true, numericality: { only_integer: true }
  validate  :vote_value_limit

  belongs_to :user
  belongs_to :votable, polymorphic: true

  def self.get_vote(user_id, value)
    find_by(value: value, user_id: user_id)
  end

  def self.update_vote(votable, user_id, value)
    begin
      vote = get_vote(user_id, value)
      if vote.blank?
        vote = votable.votes.build(user_id: user_id, value: value)

        transaction do
          votable.update!(total_votes: votable.total_votes + vote.value)
          vote.save!
        end

      else
        update_vote_cancelled_status(votable, vote)
      end

    rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordInvalid => exp
      votable.errors.add(:total_votes, exp.message)
    end
  end

  def vote_value_limit
    unless [-1, 1].include?(value)
      errors.add(:value, 'value must be either -1 or 1')
    end
  end

  def self.valid_vote_value?(value)
    ['-1', '1'].include?(value)
  end

  def self.update_vote_cancelled_status(votable, vote)
    transaction do
      vote.update!(cancelled: !vote.cancelled?)
      if vote.cancelled?
        votable.update!(total_votes: votable.total_votes - vote.value)
      else
        votable.update!(total_votes: votable.total_votes + vote.value)
      end
    end
  end
end
