module DataSetsHelper

  def data_set_catalogs(data_set)
    catalogs = data_set.catalogs
    return 'none' if catalogs.empty?
    out = content_tag(:ul)
    catalogs.each do |catalog|
      out << content_tag(:li, link_to(catalog.name, catalog_path(catalog)))
    end
    out
  end

  def data_set_categories(data_set)
    categories = data_set.categories
    return 'none' if categories.empty?
    categories.map do |category|
      link_to(category.name, category_path(category))
    end.join(', ').html_safe
  end

  def data_set_children(data_set)
    children = data_set.children
    return 'none' if children.empty?
    out = content_tag(:ul)
    children.sort_by { |ds| ds.title }.each do |ds|
      out << content_tag(:li, link_to(ds.title, data_set_path(ds)))
    end
    out
  end

  def data_set_column_visible?(columns, label)
    columns.select { |c| c[:label] == label }.first[:visible]
  end

  # Hyperlink URLs in a data set description. Also inserts soft hyphens
  # (&shy;) to help break long URLs.
  def data_set_description(data_set)
    auto_link_urls(data_set.description) do |url|
      url.gsub(/[&\/-]/, '\0&shy;')
    end
  end

  def data_set_facets(data_set)
    return 'N/A' unless data_set.parent
    facets = data_set.facets
    return '?' unless facets
    facets.map { |k, v| "#{k}:#{v}" }.join(', ')
  end

  def data_set_organization(data_set)
    organization = data_set.organization
    return '?' unless organization
    link_to(organization.name, organization_path(organization))
  end

  def data_set_parent(data_set)
    parent = data_set.parent
    return 'N/A' unless parent
    link_to(parent.title, data_set_path(parent))
  end

  def data_set_passive_rating(rating)
    average = rating['avg']
    content_tag(:meter, :min => 1, :max => 5, :value => average) do
      "#{rating} out of 5"
    end
  end

  # field_name should be a symbol
  def data_set_rating_histogram(data_set, field_name)
    histogram_image_tag(data_set.id, field_name, :class => :rating)
  end

  def data_set_distributions(data_set)
    distributions = data_set.distributions
    return nil unless distributions
    out = content_tag(:ul)
    distributions.each do |distribution|
      text = if distribution.kind == 'document'
        "#{distribution.format}"
      else
        distribution.kind
      end
      out << content_tag(:li, link_to(text, distribution.url))
    end
    out
  end

  def data_set_tags(data_set)
    tags = data_set.tags
    return 'none' if tags.empty?
    tag_names = tags.map { |t| t.name }.uniq
    tag_names.map do |name|
      link_to(name, tag_path(name))
    end.join(', ').html_safe
  end

end
