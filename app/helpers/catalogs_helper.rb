module CatalogsHelper

  def catalog_curators(catalog)
    catalog_users(catalog.curators)
  end

  def catalog_data_sets(catalog)
    count = catalog.data_sets.count
    text = pluralize(count, 'data set')
    count > 0 ? link_to(text, data_sets_path) : text
  end

  def catalog_owners(catalog)
    catalog_users(catalog.owners)
  end

  protected

  def catalog_users(users)
    return 'none' if users.empty?
    users.map do |user|
      link_to(user.name, user_path(user))
    end.join(', ').html_safe
  end

end
