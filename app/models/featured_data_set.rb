# A DataSet that is featured on the home page.
#
# Fields:
#     * start_at: time to start featuring the DataSet
#     * stop_at: time to stop featuring the DataSet
#     * note: an optional blurb. may be used to explain why the DataSet is
#       being featured
class FeaturedDataSet
  include Mongoid::Document
  include Mongoid::Timestamps
  include Validators

  # === Fields ===
  field :start_at, :type => Time
  field :stop_at,  :type => Time
  field :note,     :type => String

  # === Associations ===
  referenced_in :data_set, :index => true

  # === Indexes ===
  index :start_at
  index :stop_at

  # === Validations ===
  validates_presence_of :start_at
  validates_presence_of :data_set

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

  # Returns the currently featured data set or nil.
  def self.current(t = Time.now)
    matches = self.where(:start_at.lt => t).where(:stop_at.gt => t)
    case matches.count
    when 1
      matches.first
    when 0
      self.where(:start_at.lt => t).descending(:start_at).first
    else
      raise "Expected to find 0 or 1 matches for FeaturedDataSet"
    end
  end

end
