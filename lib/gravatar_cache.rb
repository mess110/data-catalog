class GravatarCache
  extend GravatarHelper

  @queue = :gravatar

  def self.perform(email, refresh=false)
    filename = gravatar_cached_filename(email)
    return if !refresh && File.exist?(filename)
    FileUtils.mkdir_p(File.dirname(filename))
    url = gravatar_url(email)
    system %(curl "#{url}" -o #{filename} --create-dirs)
  end

end
