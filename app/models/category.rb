# "Canonical" Categories for the whole system.
#
# Note, the various sites that get imported from also have their own
# "categories" but they are called `labels`.
#
# Fields:
#
#     primary - is this a top-level category?
class Category
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  # === Fields ===

  field :uid,         :type => String
  field :name,        :type => String
  field :description, :type => String
  slug :name
  field :primary,     :type => Boolean, :default => true

  # === Associations ===

  references_and_referenced_in_many :data_sets, :inverse_of => :categories,
    :index => true
  referenced_in :parent, :class_name => 'Category',
    :inverse_of => :children, :index => true
  references_many :children, :class_name => 'Category',
    :foreign_key => :parent_id, :inverse_of => :parent

  # === Indexes ===

  index :uid, :unique => true
  index :name, :unique => true

  # === Validations ===

  validates_presence_of :uid
  validates_uniqueness_of :uid
  validates_presence_of :name

  # === Callbacks ===

  before_save :update_primary
  def update_primary
    self.primary = parent.nil?
    true
  end
  protected :update_primary

  # === Scopes ===

  scope :primary, :where => { :primary => true }
  scope :secondary, :where => { :primary => false }

  # === Class Methods ===

  def self.find_duplicate(params)
    ModelHelper.find_duplicate(self, params, [:uid])
  end

  def self.ensure(params)
    ModelHelper.ensure(self, params)
  end

  # === Instance Methods ===

  def primary; parent.nil? end
  def primary?; primary end
  def secondary; !primary end
  def secondary?; !primary end

  protected

end
