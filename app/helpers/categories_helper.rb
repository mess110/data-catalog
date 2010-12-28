module CategoriesHelper

  def category_children(category)
    synonyms = category.children
    return 'none' if synonyms.empty?
    synonyms.sort_by { |c| c.name }.map do |category|
      link_to(category.name, category_path(category))
    end.join(', ').html_safe
  end

  def category_data_sets(category)
    count = category.data_sets.count
    text = pluralize(count, 'data set')
    count > 0 ? link_to(text, data_sets_path) : text
  end
  
  def category_parent(category)
    parent = category.parent
    return 'N/A' unless parent
    link_to(parent.name, category_path(parent))
  end

end
