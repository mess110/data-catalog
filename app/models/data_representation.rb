# A DataRepresentation is embedded in a DataSet.
#
# It may be one of these kinds:
#   * Document
#   * API
#   * Tool (an interactive tool)
#
# Documents may be one of the following formats:
#   * CSV
#   * JSON
#   * XLS
#   * XML
#
# Note: the "API" and "Tool" kinds must not supply the format.
class DataRepresentation
  include Mongoid::Document

  # === Fields ===
  field :url,    :type => String
  field :kind,   :type => String
  field :format, :type => String

  # === Associations ===
  embedded_in :data_set, :inverse_of => :data_set

  # === Indexes ===

  # === Validations ===
  validates_presence_of :url
  validates_presence_of :kind
  validates_inclusion_of :kind, :in => %w(API document tool)
  validates_inclusion_of :format, :in => %w(CSV JSON RDF XLS XML),
    :if => Proc.new { |dr| dr.kind == 'document' }

  validate :format_for_apis_and_tools
  def format_for_apis_and_tools
    if kind != 'document' && !format.nil?
      errors.add :format, "must be nil for kind #{kind}."
    end
  end

  # === Class Methods ===

  # === Instance Methods ===

end
