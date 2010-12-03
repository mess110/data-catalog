module CatalogsHelper

  def catalog_curators(catalog)
    catalog_users(catalog.curators)
  end

  def catalog_owners(catalog)
    catalog_users(catalog.owners)
  end

  def catalog_data_sources(catalog)
    text = pluralize(catalog.data_sources.count, 'data sources')
    link_to(text, data_sources_path)
  end

  protected

  def catalog_users(users)
    return 'none' if users.empty?
    users.map do |user|
      link_to(user.name, user_path(user))
    end.join(', ').html_safe
  end

end
