module ApplicationHelper
  def full_path(title = '')
    base_title = 'Stack Flow'
    if title.blank?
      base_title
    else
      "#{title} | #{base_title}"
    end
  end

  def flash_message
    html = ""

    flash.each do |key, msg|
      html << (content_tag :div, msg, class: "alert alert-#{key}")
    end

    sanitize(html)
  end
end
