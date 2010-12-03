# "Canonical" Categories for the whole system.
#
# Note, the various sites that get imported from also have their own
# "categories" but they are called `labels`.
#
class Category
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  # === Fields ===
  field :uid,  :type => String
  field :name, :type => String
  slug :name, :scoped => true

  # === Associations ===
  references_many :data_sources, :inverse_of => :categories,
    :stored_as => :array, :index => true

  # === Indexes ===
  index :uid, :unique => true

  # === Validations ===
  validates_uniqueness_of :uid
  validates_presence_of :name

  # === Class Methods ===
  def self.find_duplicate(params)
    ModelHelper.find_duplicate(self, params, [:uid])
  end

  def self.ensure(params)
    ModelHelper.ensure(self, params)
  end

  # === Instance Methods ===

end
