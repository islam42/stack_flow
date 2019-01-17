class Ability
  include CanCan::Ability
  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    user ||= User.new # guest user (not logged in)

    if user.admin?
      can :manage, :all
    elsif user.new_record?
      can :read, :all
      can %i[un_answered answered asked_last_week accepted search], Question
    else
      can :read, :all
      can %i[update destroy edit], Question, user_id: user.id
      can :create, Comment
      can :update, User, id: user.id
      can %i[destroy update edit], Answer, user_id: user.id
      can %i[upvote downvote create], Question
      can %i[upvote downvote create], Answer
      can %i[un_answered answered asked_last_week accepted search], Question
      can %i[update destroy], Comment, user_id: user.id
      can %i[accept reject], Answer
    end
  end
end
