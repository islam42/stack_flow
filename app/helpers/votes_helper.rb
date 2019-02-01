module VotesHelper
  def upvoted?(votable)
    vote = votable.votes.get_vote(current_user.id, 1)
    unless  vote.blank?
      true unless vote.cancelled?
    end
  end

  def downvoted?(votable)
    vote = votable.votes.get_vote(current_user.id, -1)
    unless  vote.blank?
      true unless vote.cancelled?
    end
  end
end