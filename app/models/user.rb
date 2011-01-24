# A user account. A User may be an administrator of a Catalog.
class User
  include Mongoid::Document
  include Mongoid::Timestamps

  devise :database_authenticatable, :confirmable, :recoverable,
    :registerable, :rememberable, :trackable, :validatable

  # === Fields ===
  field :uid,   :type => String
  field :name,  :type => String
  field :bio,   :type => String
  field :admin, :type => Boolean
  # field :email, :type => String (created by devise)

  # === Associations ===
  references_many :data_set_notes
  references_many :tags
  references_and_referenced_in_many :curated_catalogs,
    :class_name => 'Catalog', :inverse_of => :curators, :index => true
  references_and_referenced_in_many :owned_catalogs,
    :class_name => 'Catalog', :inverse_of => :owners, :index => true
  references_and_referenced_in_many :watched_data_sets,
    :class_name => 'DataSet', :inverse_of => :watchers, :index => true
  references_many :activities_as_subject, :class_name => 'Activity',
    :foreign_key => :subject_user_id, :inverse_of => :subject_user
  references_many :activities_as_object, :class_name => 'Activity',
    :foreign_key => :object_user_id, :inverse_of => :object_user

  # === Indexes ===
  index :uid, :unique => true

  # === Validations ===
  validates_presence_of :uid
  validates_uniqueness_of :uid
  validates_presence_of :name
  validates_uniqueness_of :email, :case_sensitive => false

  # === Callbacks ===
  before_validation :ensure_uid
  def ensure_uid
    return true if uid.present?
    self.uid = make_uid(name)
  end

  # === Class Methods ===
  def self.find_duplicate(params)
    ModelHelper.find_duplicate(self, params, [:uid])
  end

  def self.ensure(params)
    ModelHelper.ensure(self, params)
  end

  # === Instance Methods ===

  def to_param; uid end

  protected

  def make_uid(string)
    (string.downcase.squish + ' ').gsub(/\s/, '-') + '%04i' % rand(10000)
  end

end
