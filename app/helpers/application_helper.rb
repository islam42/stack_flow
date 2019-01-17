module ApplicationHelper
  def full_path(title = '')
    base_title = 'Stack Flow'
    if title.empty?
      base_title
    else
      "#{title} | #{base_title}"
    end
  end

  def auther?(user)
    current_user == user
  end
end
