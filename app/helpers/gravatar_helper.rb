module GravatarHelper

  BASE_URL = 'http://www.gravatar.com/avatar/'
  SIZE = 60
  DIMENSIONS = "#{SIZE}x#{SIZE}"

  def gravatar_image_tag(email, name)
    filename = gravatar_cached_filename(email)
    path = if File.exist?(filename) && CacheGravatar.fresh?(filename)
      gravatar_cached_path(email)
    else
      Resque.enqueue(CacheGravatar, email)
      gravatar_url(email)
    end
    image_tag(path, :alt => name, :size => DIMENSIONS)
  end

  def gravatar_url(email)
    BASE_URL + gravatar_id(email) + "?d=identicon&s=#{SIZE}"
  end

  def gravatar_cached_path(email)
    '/images/gravatars/' + gravatar_basename(email)
  end

  def gravatar_cached_filename(email)
    Rails.root.join('public/images/gravatars', gravatar_basename(email))
  end

  def gravatar_id(email)
    Digest::MD5.hexdigest(email.downcase)
  end

  protected

  def gravatar_basename(email)
    "#{gravatar_id(email)}-#{DIMENSIONS}.png"
  end

end
