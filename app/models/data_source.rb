# A DataSource:
#   * belongs to one or more Catalogs
#   * may be published or shared in one or more "ways"
#     - formats such as CSV, XML, XLS
#     - API's
#     - interactive tools
#
# Notes:
#
# === data_quality ===
#
# An integer rating between 1 (low) and 5 (high), or nil.
#
# === documentation_quality ===
#
# An integer rating between 1 (low) and 5 (high), or nil.
#
# === interestingness ===
#
# An integer rating between 1 (low) and 5 (high), or nil.
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
  include Validators

  # === Fields ===
  field :uid,                   :type => String
  field :title,                 :type => String
  field :url,                   :type => String
  field :description,           :type => String
  field :documentation_url,     :type => String
  field :license,               :type => String
  field :license_url,           :type => String
  field :released,              :type => Hash
  field :updated,               :type => Hash
  field :period_start,          :type => Hash
  field :period_end,            :type => Hash
  field :frequency,             :type => String
  field :missing,               :type => Boolean, :default => false
  field :facets,                :type => Hash
  field :granularity,           :type => String
  field :geographic_coverage,   :type => String
  field :data_quality,          :type => Integer, :default => nil
  field :documentation_quality, :type => Integer, :default => nil
  field :interestingness,       :type => Integer, :default => nil
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
  references_many :activities_as_object, :class_name => 'Activity',
    :foreign_key => :object_data_source_id, :inverse_of => :object_data_source

  # === Indexes ===
  index :uid, :unique => true

  # === Validations ===
  validates_uniqueness_of :uid
  validates_presence_of :title
  validates_associated :data_representations

  validate :validate_kronos_hashes
  def validate_kronos_hashes
    expect_kronos_hash(released,     :released)
    expect_kronos_hash(period_start, :period_start)
    expect_kronos_hash(period_end,   :period_end)
  end

  # === Scopes ===
  # These return DataSources that have one or more DataRepresentations:
  scope :apis,      :where => { 'data_representations.kind' => 'api' }
  scope :documents, :where => { 'data_representations.kind' => 'document' }
  scope :tools,     :where => { 'data_representations.kind' => 'tool' }
  scope :top_level, :where => { :parent_id => nil }

  # === Map/Reduce ===
  MR = MapReduce.load_files(self, 'data_representation_counts')
  def self.data_representation_counts
    result = self.collection.map_reduce(*MR).find
    result.reduce({}) { |h, x| h.merge({ x['_id'] => x['value'].to_i }) }
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
