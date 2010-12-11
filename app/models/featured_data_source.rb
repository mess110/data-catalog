# A DataSource that is featured on the home page.
#
# Fields:
#     * start_at: time to start featuring the DataSource
#     * stop_at: time to stop featuring the DataSource
#     * note: an optional blurb. may be used to explain why the DataSource is
#       being featured
class FeaturedDataSource
  include Mongoid::Document
  include Mongoid::Timestamps
  include Validators

  # === Fields ===
  field :start_at, :type => Time
  field :stop_at,  :type => Time
  field :note,     :type => String

  # === Associations ===
  referenced_in :data_source, :index => true

  # === Indexes ===

  # === Validations ===
  validates_presence_of :start_at
  validates_presence_of :data_source

  validate :validate_times
  def validate_times
    unless start_at
      errors.add(:start_at, "can't be blank")
      return
    end
    if stop_at && start_at > stop_at
      errors.add(:stop_at, "must be later than start_at")
    end
  end

  # === Scopes ===

  # === Map/Reduce ===

  # === Class Methods ===
  def self.find_duplicate(params)
    ModelHelper.find_duplicate(self, params, [:start_at, :stop_at])
  end

  def self.ensure(params)
    ModelHelper.ensure(self, params)
  end

  # === Instance Methods ===

end
