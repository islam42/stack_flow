class QuestionActivityMailer < ApplicationMailer
  default from:"islam0322@gmail.com"

  def question_activity(user, question, subject)
    @user = user
    @question = question
    mail(to: 'islam0322@gmail.com', subject: subject)
  end
end
