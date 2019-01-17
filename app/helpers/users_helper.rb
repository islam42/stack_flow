module UsersHelper
  def gravatar_for(user, size = 10)
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    gravatar_url = "http://secure.gravatar.com/avatar/#{gravatar_id}"
    image_tag(gravatar_url, size: size, alt: user.name, class: 'gravatar')
  end
end
