module UsersHelper
  def avatar_for(user)
    gravatar_id = Digest::MD5::hexdigest(user.email)
    url = "https://secure.gravatar.com/avatar/#{gravatar_id}?d=identicon&s=60"
    image_tag(url, alt: user.username, class: 'gravatar')
  end
end
