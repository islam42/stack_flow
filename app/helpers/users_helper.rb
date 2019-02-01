module UsersHelper
  def gravatar_for(user_name, user_email, size = 10)
    gravatar_id = Digest::MD5.hexdigest(user_email.downcase)
    gravatar_url = "http://secure.gravatar.com/avatar/#{gravatar_id}"
    image_tag(gravatar_url, size: size, alt: user_name, class: 'gravatar')
  end

  def auther?(authorizable)
    current_user.auther?(authorizable)
  end
end
