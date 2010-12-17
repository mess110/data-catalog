module SitesHelper

  def site_api_tag(site)
    url = site.api_url
    if !url
      site_boolean(false)
    elsif url == '?'
      content_tag(:span, '?', :class => :unsure)
    else
      link_to(image_tag('api-icon-28x28.png', :size => '28x28',
        :alt => 'API', :class => :api), url)
    end
  end

  def site_boolean(bool)
    entity = bool ? '&#x2713;' : '&#x2715;'
    css_class = bool ? 'yes' : 'no'
    content_tag(:span, entity.html_safe, :class => css_class)
  end

  def site_platform_link(site)
    name, url = site.platform_name, site.platform_url
    if name == '?'
      content_tag(:span, '?', :class => :unsure)
    else
      url ? link_to(name, url) : name
    end
  end

  def site_platform_source(site)
    case site.platform_source
    when 'closed'
      content_tag(:span, 'closed', :class => :closed)
    when 'open'
      content_tag(:span, 'open', :class => :open)
    when '?'
      content_tag(:span, '?', :class => :unsure)
    end
  end

  def site_rss_tag(site)
    url = site.rss_url
    if !url
      site_boolean(false)
    elsif url == '?'
      content_tag(:span, '?', :class => :unsure)
    else
      link_to(image_tag('feed-icon-28x28.png', :size => '28x28',
        :alt => 'RSS', :class => :rss), url)
    end
  end

end
