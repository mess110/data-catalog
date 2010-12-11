# An Activity describes a User action in the application.
#
# Each activity can be described as subject-verb-object sentence. These are
# the kinds of activities:
#
#   "#{subject_label} signed up."
#   "#{subject_label} started following #{object_label}."
#   "#{subject_label} started watching #{object_label}."
#   "#{subject_label} commented on #{object_label}."
#   "#{subject_label} suggested a data source called #{object_label}."
#
# This model (e.g. collection in the database) is designed to be quick to
# read without joins. So it is denormalized. This is why I have these fields:
#
#     * subject_label : a User name
#     * subject_path  : a User path
#     * object_label  : either a User name or a DataSource title
#     * object_path   : either a User path or a DataSource path
#
# Associations are prefixed with `subject_` or `object_` to make things extra
# clear. Who knows, we may add more activity types and associations, so I
# don't want to get locked in to confusing names.
#
# An Activity is is part of an activity stream. There are several activity
# streams, all derived from this model:
#
#    * There is an application-wide activity stream
#    * Each User has an activity stream
#    * Each DataSource has an activity stream
#    * Each Catalog has an activity stream
#
# Note that if object_data_source is set, then object_catalogs will be set
# automatically. Why? If you specify a DataSource as an object, then we
class Activity
  include Mongoid::Document
  include Mongoid::Timestamps

  # === Fields ===
  field :subject_label, :type => String
  field :subject_path,  :type => String
  field :verb,          :type => String
  field :object_label,  :type => String
  field :object_path,   :type => String

  # === Associations ===
  referenced_in :subject_user, :class_name => 'User', :index => true
  referenced_in :object_user, :class_name => 'User', :index => true
  referenced_in :object_data_source, :class_name => 'DataSource',
    :index => true

  # === Indexes ===

  # === Validations ===
  validates_presence_of :subject_user
  validates_presence_of :subject_label
  validates_presence_of :subject_path
  validates_presence_of :verb
  validates_inclusion_of :verb, :in =>
    %w(sign-up follow watch comment suggest)

  validate :fields_for_verb
  def fields_for_verb
    case verb
    when 'sign-up'
      expect(:object_label,       :nil)
      expect(:object_path,        :nil)
      expect(:object_user,        :nil)
      expect(:object_data_source, :nil)
    when 'follow'
      expect(:object_label,       :truthy)
      expect(:object_path,        :truthy)
      expect(:object_user,        :truthy)
      expect(:object_data_source, :nil)
    when 'comment', 'suggest', 'watch'
      expect(:object_label,       :truthy)
      expect(:object_path,        :truthy)
      expect(:object_user,        :nil)
      expect(:object_data_source, :truthy)
    end
  end

  # === Callbacks ===

  # === Scopes ===

  # === Map/Reduce ===

  # === Class Methods ===
  def self.find_duplicate(params)
    ModelHelper.find_duplicate(self, params,
      [:subject_path, :verb, :object_path])
  end

  def self.ensure(params)
    ModelHelper.ensure(self, params)
  end

  # === Instance Methods ===

  protected

  def expect(field, expected)
    actual = self.send(field)
    return if expected == :nil && actual.nil?
    return if expected == :empty && actual == []
    return if expected == :truthy && actual
    errors.add(field, "must be #{expected} for #{verb}")
  end

end
