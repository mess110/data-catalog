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

  # === Class Methods ===
  def self.find_duplicate(params)
    # Note: may not work quite right, since :site is an association
    ModelHelper.find_duplicate(self, params, [:name, :site])
  end

  def self.ensure(params)
    ModelHelper.ensure(self, params)
  end

  # === Instance Methods ===

end
