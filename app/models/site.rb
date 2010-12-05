# An external site; e.g. data.gov.
#
# I didn't call this a "Catalog" for two reasons:
# 1. I'm already using Catalog to mean "internal to this app" Catalogs.
# 2. Many sites don't deserve to be called "data catalogs". "Site" is ok.
#
# By "index page" I mean one page that lists all data sets -- it might be
# paginated.
#
# By "detail pages" I mean one detail page for each data set -- with metadata.
# A link to an agency site is not sufficient, because the metadata has a very
# low chance of being extractable in a generalized way.
class Site
  include Mongoid::Document
  include Mongoid::Timestamps

  # === Fields ===
  field :uid,             :type => String  #
  field :name,            :type => String  #
  field :url,             :type => String  #
  field :org_type,        :type => String  # Organization type
  field :description,     :type => String  #
  field :launched_on,     :type => Date    #
  field :launch_urls,     :type => Array   #
  field :platform_name,   :type => String  #
  field :platform_url,    :type => String  #
  field :platform_source, :type => String  # describes platform source code
  field :index_page,      :type => Boolean # Has an index page (a listing)?
  field :detail_pages,    :type => Boolean # Has detail pages?
  field :rss_url,         :type => String  # Main RSS url, if present
  field :api_url,         :type => String  # API URL, if present

  # === Associations ===
  referenced_in :organization, :index => true
  referenced_in :location, :index => true

  # === Indexes ===
  index :uid, :unique => true
  index :name, :unique => true

  # === Validations ===
  validates_presence_of :uid
  validates_uniqueness_of :uid
  validates_presence_of :url
  validates_uniqueness_of :url, :case_sensitive => false
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_presence_of :type
  validates_inclusion_of :org_type,
    :in => %w(? government not-for-profit other)
  validates_inclusion_of :platform_source, :in => %w(? open closed other)

  # === Class Methods ===
  def self.find_duplicate(params)
    ModelHelper.find_duplicate(self, params, [:uid])
  end

  def self.ensure(params)
    ModelHelper.ensure(self, params)
  end

  # === Instance Methods ===
  def to_param; uid end

end
