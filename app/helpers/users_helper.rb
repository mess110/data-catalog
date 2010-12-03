module UsersHelper

  def user_owned_catalogs(user)
    user_catalogs(user.owned_catalogs)
  end

  def user_curated_catalogs(user)
    user_catalogs(user.curated_catalogs)
  end

  protected

  def user_catalogs(catalogs)
    return 'none' if catalogs.empty?
    catalogs.map do |catalog|
      link_to(catalog.name, catalog_path(catalog))
    end.join(', ').html_safe
  end

end
