# A private note by a particular user about a particular data set.
class DataSetNote
  include Mongoid::Document
  include Mongoid::Timestamps

  # === Fields ===

  field :content, :type => String

  # === Associations ===

  referenced_in :data_set, :index => true
  referenced_in :user, :index => true

  # === Validations ===

  validates_presence_of :content

  # === Callbacks ===

  # === Scopes ===

  # === Class Methods ===

  # === Instance Methods ===

  protected

end
