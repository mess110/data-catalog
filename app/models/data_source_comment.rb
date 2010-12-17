class DataSourceComment
  include Mongoid::Document
  include Mongoid::Timestamps

  # === Fields ===
  field :content, :type => String

  # === Associations ===

  # === Indexes ===

  # === Validations ===
  validates_presence_of :text

  # === Scopes ===

  # === Class Methods ===
  def self.find_duplicate(params)
    raise "Not implemented"
    ModelHelper.find_duplicate(self, params, [:id])
  end

  def self.ensure(params)
    ModelHelper.ensure(self, params)
  end

  # === Instance Methods ===

end
