module GravatarHelper

  BASE_URL = 'http://www.gravatar.com/avatar/'
  SIZE = 59

  def gravatar_image_tag(user)
    email = user.email
    path = if File.exist?(gravatar_cached_filename(email))
      gravatar_cached_path(email)
    else
      Resque.enqueue(GravatarCache, email)
      gravatar_url(email)
    end
    image_tag(path, :alt => user.name, :size => "#{SIZE}x#{SIZE}")
  end

  def gravatar_url(email)
    BASE_URL + gravatar_id(email) + "?d=identicon&s=#{SIZE}"
  end

  def gravatar_cached_path(email)
    "/images/gravatars/#{gravatar_id(email)}.png"
  end

  def gravatar_cached_filename(email)
    Rails.root.join "public/images/gravatars/#{gravatar_id(email)}.png"
  end

  def gravatar_id(email)
    Digest::MD5.hexdigest(email.downcase)
  end

end
