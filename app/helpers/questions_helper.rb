module QuestionsHelper
  def question_search_tags(question)
    tags = ''
    question.tags.split(',').each do |tag|
      tags << (link_to tag, root_path(search_content: tag))
    end
    sanitize(tags)
  end
end