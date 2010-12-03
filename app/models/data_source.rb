# A DataSource:
#   * belongs to one or more Catalogs
#   * may be published or shared in one or more "ways"
#     - formats such as CSV, XML, XLS
#     - API's
#     - interactive tools
#
# Notes:
#
# === url ===
#
# May be left blank: it often makes sense for a DataSource with children to
# leave the `url` field blank. This is because such a DataSource acts like
# an aggregate. Such children will often have their own download urls.
#
class DataSource
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Versioning
  include Mongoid::Slug
  
  # === Fields ===
  field :uid,                   :type => String
  field :title,                 :type => String
  field :url,                   :type => String
  field :description,           :type => String
  field :documentation_url,     :type => String
  field :license,               :type => String
  field :license_url,           :type => String
  field :released,              :type => Hash
  field :period_start,          :type => Hash
  field :period_end,            :type => Hash
  field :frequency,             :type => String
  field :missing,               :type => Boolean, :default => false
  field :facets,                :type => Hash
  field :granularity,           :type => String
  field :geographic_coverage,   :type => String
  field :interestingness,       :type => Integer, :default => nil
  field :documentation_quality, :type => Integer, :default => nil
  field :data_quality,          :type => Integer, :default => nil
  slug :title, :scoped => true

  # === Associations ===
  embeds_many :data_representations
  references_many :data_source_notes
  references_many :tags
  referenced_in :organization, :index => true
  references_many :catalogs, :inverse_of => :data_sources,
    :stored_as => :array, :index => true
  references_many :categories, :inverse_of => :data_sources,
    :stored_as => :array, :index => true
  referenced_in :parent, :class_name => 'DataSource',
    :inverse_of => :children, :index => true
  references_many :children, :class_name => 'DataSource',
    :foreign_key => :parent_id, :inverse_of => :parent
  references_many :watchers, :class_name => 'User',
    :inverse_of => :watched_data_sources, :stored_as => :array,
    :index => true

  # === Indexes ===
  index :uid, :unique => true

  # === Validations ===
  validates_uniqueness_of :uid
  validates_presence_of :title
  validates_associated :data_representations
  
  # === Scopes ===
  # These return DataSources that have one or more DataRepresentations:
  scope :apis,      :where => { 'data_representations.kind' => 'api' }
  scope :documents, :where => { 'data_representations.kind' => 'document' }
  scope :tools,     :where => { 'data_representations.kind' => 'tool' }
  scope :top_level, :where => { :parent_id => nil }
  
  # === Map/Reduce ===
  MR = MapReduce.load_files(self, 'data_representation_counts')
  def self.data_representation_counts
    result = self.collection.map_reduce(*MR)
    h = {}
    result.find.each { |x| h[x['_id'].intern] = x['value'].to_i }
    h
  end

  # === Class Methods ===
  def self.find_duplicate(params)
    ModelHelper.find_duplicate(self, params, [:uid])
  end

  def self.ensure(params)
    ModelHelper.ensure(self, params)
  end

  # === Instance Methods ===

end
