# A Catalog is a catalog within this application. This application allows 1 or
# more Catalogs.
#
# Please Do not confuse this model (Catalog) with Site (which is used to point
# to external web sites, including data catalogs such as data.gov).
class Catalog
  include Mongoid::Document
  include Mongoid::Timestamps

  # === Fields ===
  field :uid,         :type => String
  field :name,        :type => String
  field :path,        :type => String # internal URL path
  field :description, :type => String

  # === Associations ===
  references_many :data_sources, :inverse_of => :catalogs,
    :stored_as => :array, :index => true
  references_many :curators, :class_name => 'User',
    :inverse_of => :curated_catalogs, :stored_as => :array, :index => true
  references_many :owners, :class_name => 'User',
    :inverse_of => :owned_catalogs, :stored_as => :array, :index => true

  # === Indexes ===
  index :uid, :unique => true
  index :name, :unique => true

  # === Validations ===
  validates_uniqueness_of :uid
  validates_presence_of :name
  validates_presence_of :path
  validates_uniqueness_of :path

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
