# A private note by a particular user about a particular data source.
class DataSourceNote
  include Mongoid::Document
  include Mongoid::Timestamps

  # === Fields ===
  field :content, :type => String

  # === Associations ===
  referenced_in :data_source, :index => true
  referenced_in :user, :index => true

  # === Validations ===
  validates_presence_of :content

  # === Class Methods ===

  # === Instance Methods ===

end
