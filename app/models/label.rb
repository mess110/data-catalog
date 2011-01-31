# Sites have various "categorization" or "labelling" schemes. This model
# captures these labels.
class Label
  include Mongoid::Document
  include Mongoid::Timestamps

  # === Fields ===

  field :name, :type => String
  field :url,  :type => String

  # === Associations ===

  referenced_in :site

  # === Validations ===

  validates_presence_of :name
  validates_presence_of :site

  # === Callbacks ===

  # === Scopes ===

  # === Class Methods ===

  def self.find_duplicate(params)
    raise "Probably implemented wrong"
    # Note: I have very little confidence that this is correct, because :site
    # is an association, not a 'regular' field.
    #
    # The params that get passed in typically come from .yml files that are
    # processed by the DataLoader class.
    #
    # One possible change is to modify the DataLoader to call its `transform`
    # method earlier in its process so that association lookups happen and
    # are converted to, for example, :site_id before this `find_duplicate`
    # is called.
    ModelHelper.find_duplicate(self, params, [:name, :site])
  end

  def self.ensure(params)
    ModelHelper.ensure(self, params)
  end

  # === Instance Methods ===

  protected

end
