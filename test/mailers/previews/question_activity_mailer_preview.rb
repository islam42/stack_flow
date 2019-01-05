# Preview all emails at http://localhost:3000/rails/mailers/question_activity_mailer
class QuestionActivityMailerPreview < ActionMailer::Preview

 def question_activity_preview
    QuestionActivityMailer.question_activity(User.first, Question.last, 'New Answer posted')
  end
end
