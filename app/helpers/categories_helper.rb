module CategoriesHelper

  def category_children(category)
    synonyms = category.children
    return 'none' if synonyms.empty?
    synonyms.sort_by { |c| c.name }.map do |category|
      link_to(category.name, category_path(category))
    end.join(', ').html_safe
  end

  def category_data_sources(category)
    count = category.data_sources.count
    text = pluralize(count, 'data source')
    count > 0 ? link_to(text, data_sources_path) : text
  end
  
  def category_parent(category)
    parent = category.parent
    return 'N/A' unless parent
    link_to(parent.name, category_path(parent))
  end

end
