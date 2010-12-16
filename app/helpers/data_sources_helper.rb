module DataSourcesHelper

  def data_source_catalogs(data_source)
    catalogs = data_source.catalogs
    return 'none' if catalogs.empty?
    out = content_tag(:ul)
    catalogs.each do |catalog|
      out << content_tag(:li, link_to(catalog.name, catalog_path(catalog)))
    end
    out
  end

  def data_source_categories(data_source)
    categories = data_source.categories
    return 'none' if categories.empty?
    categories.map do |category|
      link_to(category.name, category_path(category))
    end.join(', ').html_safe
  end

  def data_source_children(data_source)
    children = data_source.children
    return 'none' if children.empty?
    out = content_tag(:ul)
    children.sort_by { |ds| ds.title }.each do |ds|
      out << content_tag(:li, link_to(ds.title, data_source_path(ds)))
    end
    out
  end

  def data_source_facets(data_source)
    return 'N/A' unless data_source.parent
    facets = data_source.facets
    return '?' unless facets
    facets.map { |k, v| "#{k}:#{v}" }.join(', ')
  end

  def data_source_organization(data_source)
    organization = data_source.organization
    return '?' unless organization
    link_to(organization.name, organization_path(organization))
  end

  def data_source_parent(data_source)
    parent = data_source.parent
    return 'N/A' unless parent
    link_to(parent.title, data_source_path(parent))
  end

  def data_source_passive_rating(rating)
    average = rating['avg']
    content_tag(:meter, :min => 1, :max => 5, :value => average) do
      "#{rating} out of 5"
    end
  end

  def data_source_active_rating(rating)
    average = rating['avg']
    content_tag(:form) do
      content_tag(:div, :class => 'rating_read_only hidden') do
        (1 .. 5).map do |x|
          radio_button_tag('the_name', x, x == average.floor)
        end.join
      end
    end
  end

  def data_source_representations(data_source)
    representations = data_source.data_representations
    return nil unless representations
    out = content_tag(:ul)
    representations.each do |rep|
      text = if rep.kind == 'document'
        "#{rep.format}"
      else
        rep.kind
      end
      out << content_tag(:li, link_to(text, rep.url))
    end
    out
  end

  def data_source_tags(data_source)
    tags = data_source.tags
    return 'none' if tags.empty?
    tag_names = tags.map { |t| t.name }.uniq
    tag_names.map do |name|
      link_to(name, tag_path(name))
    end.join(', ').html_safe
  end

  def data_source_column_visible?(columns, label)
    columns.select { |c| c[:label] == label }.first[:visible]
  end

  def data_source_description(data_source)
    auto_link_urls(data_source.description) do |url|
      url.gsub('/', '/&shy;').html_safe
    end
  end

  # Hyperlink URLs in a data source description. Also inserts soft hyphens
  # (&shy;) to help break long URLs.
  def data_source_description(data_source)
    auto_link_urls(data_source.description) do |url|
      url.gsub(/[&\/-]/, '\0&shy;')
    end
  end

  # field should be a symbol
  def data_source_rating_histogram(data_source, field_name)
    histogram_image_tag(data_source.id, field_name, :class => :rating)
  end

end
