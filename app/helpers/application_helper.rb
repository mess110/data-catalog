module ApplicationHelper
  include GravatarHelper

  def shorter_url(url)
    s = url.gsub(%r(http[s]?://(www\.)?), '')
    truncate(s, :length => 20)
  end

  def kronos_to_s(kronos_hash)
    return '?' if kronos_hash.blank?
    k = Kronos.from_hash(kronos_hash)
    k.valid? ? k.to_s : '?'
  end

  def kronos_range_to_s(k1, k2)
    s1, s2 = kronos_to_s(k1), kronos_to_s(k2)
    (s1 == '?' || s2 == '?') ? '?' : "#{s1} to #{s2}"
  end

  def try_link_to(text, url)
    if text.present? && url.present?
      link_to(text, url)
    elsif text.present?
      text
    elsif url.present?
      link_to('link', url)
    else
      '?'
    end
  end
  
  def url_only(url)
    url.present? ? link_to(url, url) : '?'
  end

  def tab(css_class, text, path)
    classes = [css_class]
    classes << 'active' if current_page?(path)
    content_tag(:li, :class => classes.join(' ')) do
      link_to(text, path)
    end
  end

end
