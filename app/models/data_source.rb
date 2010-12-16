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
# === documentation_quality ===
# === interestingness ===
#
# {
#   'avg'  => 3.5,
#   'min'  => 2,
#   'max'  => 5
#   'bins' => [0, 3, 12, 11, 5],
# }
#
# Rating explanation:
#   1 : poor
#   2 : fair
#   3 : average
#   4 : good
#   5 : excellent
#
# The 'bins' key means:
#    0 ratings as a 1 (poor)
#    3 ratings as a 2 (fair)
#   12 ratings as a 3 (average)
#   11 ratings as a 4 (good)
#    5 ratings as a 5 (excellent)
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
  field :period_start,          :type => Hash
  field :period_end,            :type => Hash
  field :released,              :type => Hash
  field :updated,               :type => Hash
  field :frequency,             :type => String
  field :missing,               :type => Boolean, :default => false
  field :facets,                :type => Hash
  field :granularity,           :type => String
  field :geographic_coverage,   :type => String
  field :data_quality,          :type => Hash,    :default => {}
  field :documentation_quality, :type => Hash,    :default => {}
  field :interestingness,       :type => Hash,    :default => {}
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

  validate :validate_all_ratings
  def validate_all_ratings
    expect_ratings_hash(data_quality,          :data_quality)
    expect_ratings_hash(documentation_quality, :documentation_quality)
    expect_ratings_hash(interestingness,       :interestingness)
  end

  # === Callbacks ===
  after_validation :process_all_ratings
  def process_all_ratings
    process_ratings!(data_quality)
    process_ratings!(documentation_quality)
    process_ratings!(interestingness)
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

  protected

  # note: modifies value
  def process_ratings!(value)
    value = {} if value.blank?
    value['bins'] = [0, 0, 0, 0, 0] if value['bins'].blank?
    stats = calculate_statistics(value)
    value['min'] = stats[:min]
    value['max'] = stats[:max]
    value['avg'] = stats[:avg]
  end

  def calculate_statistics(value)
    min, max, avg = nil, nil, nil
    weighted_sum, total_count = 0, 0
    value['bins'].each_with_index do |count, i|
      rating = i + 1
      total_count += count
      weighted_sum += count * rating
      if count > 0
        min = rating unless min
        max = rating
      end
    end
    {
      :min => min,
      :max => max,
      :avg => total_count == 0 ? nil : weighted_sum / total_count.to_f
    }
  end

  def weighted_average(bins)
    sum, n = 0, 0
    bins.each_with_index do |v, i|
      n += v
      sum += v * (i + 1)
      puts "#{v} #{i + 1} | #{sum}"
    end
    sum / n.to_f
  end
end
