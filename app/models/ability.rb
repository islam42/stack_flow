class Ability
  include CanCan::Ability
  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    user ||= User.new # guest user (not logged in)

    if user.admin?
      can :manage, :all
      cannot [:destroy, :update], User, id: user.id
    elsif user.persisted?
      if user.activated?
        can [:create, :update_vote], Question
        can [:edit, :update, :destroy], Question, user_id: user.id
        can [:edit, :update, :destroy], Answer, user_id: user.id
        can [:create, :update_vote], Answer
        can :update_accept_status, Answer, question: { user_id: user.id }
        can :create, Comment
        can [:edit, :update, :destroy], Comment, user_id: user.id
      end
    end
    can :read, :all
  end
end
