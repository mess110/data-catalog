# A physical location, such as a country, state, or city.
class Location
  include Mongoid::Document
  include Mongoid::Timestamps
  
  # === Fields ===
  field :uid,           :type => String  #
  field :name,          :type => String  #
  field :abbreviation,  :type => String  #

  # === Associations ===
  references_many :organizations
  references_many :sites
  referenced_in :parent, :class_name => 'Location', :inverse_of => :children,
    :index => true
  references_many :children, :class_name => 'Location',
    :foreign_key => :parent_id, :inverse_of => :parent

  # === Indexes ===
  index :uid, :unique => true

  # === Validations ===
  validates_presence_of :uid
  validates_uniqueness_of :uid
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_uniqueness_of :abbreviation, :allow_nil => true

  # === Class Methods ===
  def self.find_duplicate(params)
    ModelHelper.find_duplicate(self, params, [:uid])
  end

  def self.ensure(params)
    ModelHelper.ensure(self, params)
  end

  # === Instance Methods ===

end
