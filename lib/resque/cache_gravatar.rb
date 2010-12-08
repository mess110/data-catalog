class CacheGravatar
  extend GravatarHelper

  @queue = :gravatar

  def self.perform(email)
    filename = gravatar_cached_filename(email)
    return if File.exist?(filename) && fresh?(filename)
    url = gravatar_url(email)
    system %(curl "#{url}" -o #{filename} --create-dirs)
  end

  def self.fresh?(filename, threshold = 1.hour)
    Time.now - File.mtime(filename) < threshold
  end

end
