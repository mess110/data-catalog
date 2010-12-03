# User-defined tags for the whole system.
#
# See also: Category, Label
class Tag
  include Mongoid::Document
  include Mongoid::Timestamps

  # === Fields ===
  field :name, :type => String

  # === Associations ===
  referenced_in :data_source, :index => true
  referenced_in :user, :index => true

  # === Indexes ===

  # === Validations ===
  validates_presence_of :name

  # === Class Methods ===
  def self.find_duplicate(params)
    ModelHelper.find_duplicate(self, params, [:name])
  end

  def self.ensure(params)
    ModelHelper.ensure(self, params)
  end

  # === Instance Methods ===

end
