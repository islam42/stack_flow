class VotesController < ApplicationController

  def upvote

    @answer.update_attribute('votes', @answer.votes + 1)
    respond_to do |format|
      format.json { render json: @answer.votes }
    end
  end
  def downvote
    @answer
    @answer.update_attribute('votes', @answer.votes - 1)
    respond_to do |format|
      format.json { render json: @answer.votes }
    end
  end
end
