class QuestionActivityMailer < ApplicationMailer
  default from: 'stackflow.com'

  def question_activity(user, question, subject, body)
    @user = user
    @question = question
    @body = body
    mail(to: question.user_email, subject: subject)
  end
end
