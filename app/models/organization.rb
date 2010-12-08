# An organization, such as a government agency or court.
# 
# Notes:
#
# === abstract ===
#
# An abstract organization is one is not a 'true' organization; instead, it
# is only used for grouping purposes. Some examples include:
# * U.S. District Courts
# * U.S. Executive Departments
#
# Some good litmus tests for an abstract organization are:
# * "Is this organization only a grouping of other organizations?"
# * "Does this organization exist in name only?"
# * "Does this organization have a particular person in charge of it?"
#
class Organization
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Versioning
  include Mongoid::Slug

  # === Fields ===
  field :uid,         :type => String
  field :name,        :type => String
  field :other_names, :type => Array
  field :url,         :type => String
  field :acronym,     :type => String
  field :description, :type => String
  field :abstract,    :type => Boolean, :default => false
  slug :name, :scoped => true

  # === Associations ===
  referenced_in :location, :index => true
  references_many :data_sources
  references_many :sites
  referenced_in :parent, :class_name => 'Organization',
    :inverse_of => :children, :index => true
  references_many :children, :class_name => 'Organization',
    :foreign_key => :parent_id, :inverse_of => :parent

  # === Indexes ===
  index :uid, :unique => true
  index :name, :unique => true

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
