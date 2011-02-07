class DataSetsController < ApplicationController

  respond_to :html, :json

  def index
    @data_sets = DataSet.top_level
    setup_for_advanced_search
    respond_with(@data_sets)
  end

  def show
    @data_set = DataSet.where(:slug => params[:id]).first
    @data_set ? respond_with(@data_set) : render_status(404)
  end

  def new
    @data_set = DataSet.new
    setup_for_editing
    respond_with(@data_set)
  end

  def edit
    @data_set = DataSet.where(:slug => params[:id]).first
    render_status(404) && return unless @data_set
    setup_for_editing
    respond_with(@data_set)
  end

  def create
    @data_set = DataSet.new(params[:data_set])
    respond_with(@data_set)
  end

  def update
    @data_set = DataSet.where(:slug => params[:id]).first
    update_data_set(@data_set)
    case params[:commit]
    when "Save"
      redirect_to @data_set
    when "Save and continue editing"
      redirect_to [:edit, @data_set]
    else
      raise "Unexpected submit action: #{params[:commit]}"
    end
  end

  # (This is a custom verb, not your usual REST CRUD.)
  def search
    filters = get_active_filters
    columns = get_columns_array
    new_params = make_new_search_params(params, filters, columns)
    redirect_to({ :action => :index }.merge(new_params))
  end

  protected

  def update_data_set(data_set)
    data_set_params = params[:data_set]
    data_set.update_attributes!(data_set_params.slice(
      :title,
      :keywords,
      :url,
      :description,
      :documentation_url,
      :license, 
      :license_url,
      :period_start,
      :period_end,
      :released,
      :updated,
      :frequency,
      :missing,
      :facets,
      :granularity,
      :geographic_coverage,
    ))
    data_set.category_ids = data_set_params[:category_ids]
    data_set.catalog_ids = data_set_params[:catalog_ids]
    data_set.save!
  end

  def basic_fields
    params[:data_set]
  end

  def setup_for_editing
    @organizations      = Organization.ascending(:name)
    @categories         = Category.ascending(:name)
    @primary_categories = Category.primary.ascending(:name)
    @catalogs           = Catalog.ascending(:name)
    @data_sets          = DataSet.ascending(:title)
  end

  def get_active_filters
    filters = get_filters_array
    append!(filters, params[:filter])
    remove_filter = params[:remove_filter]
    filters.delete(remove_filter) if remove_filter
    filters
  end

  def get_filters_array
    filters = params[:filters]
    if filters
      filters.split(',')
    else
      []
    end
  end

  # Move +item+ to the end of +array+, if present.
  # Otherwise, add +item+ to the end.
  def append!(array, item)
    if item.present?
      array.reject! { |x| x == item }
      array << item
    end
  end

  def get_columns_array
    columns = params[:columns]
    if columns
      columns.split(',')
    else
      COLUMNS.select { |c| c[:default] }.map { |c| c[:code] }
    end
  end

  # Removing a filter also removes associated form fields.
  def make_new_search_params(params, filters, columns)
    h = {
       :filters => filters.join(','),
       :columns => columns.join(','),
    }
    filters.each do |code|
      row = FILTERS.select { |f| f[:code] == code }.first
      row[:codes].each { |p| h[p] = params[p] }
    end
    h.delete_if { |k, v| v.blank? }
  end

  def setup_for_advanced_search
    filter_setup
    column_setup
    other_setup
  end

  def filter_setup
    @active_filters = get_filters_array.reverse.map do |code|
      FILTERS.select { |f| f[:code] == code }.first
    end
    @filter_options = FILTERS.map { |f| [f[:text], f[:code]] }
  end

  def column_setup
    active_columns = get_columns_array
    @columns = COLUMNS.map do |c|
      {
        :text    => c[:text],
        :label   => c[:label],
        :code    => c[:code],
        :visible => active_columns.include?(c[:code])
      }
    end
  end

  def other_setup
    @ratings = [
      ['1 - poor',      '1'],
      ['2 - fair',      '2'],
      ['3 - average',   '3'],
      ['4 - good',      '4'],
      ['5 - excellent', '5'],
    ]
    @missing = [
      ['missing',   '1'],
      ['available', '0']
    ]
    @catalogs = Catalog.ascending(:name).map { |x| [x.name, x.uid] }
    @distribution_kinds = %w(API document tool).map { |f| [f, f] }
    @distribution_formats = %w(CSV JSON RDF XLS XML).map { |f| [f, f] }
  end

  FILTERS = [
    { :text => 'Select a filter...'    , :label => nil                    , :code => ''   , :codes => %w() },
    { :text => 'Keywords'              , :label => :keywords              , :code => 'k'  , :codes => %w(k) },
    { :text => 'Title'                 , :label => :title                 , :code => 'ti' , :codes => %w(ti) },
    { :text => 'Description'           , :label => :description           , :code => 'de' , :codes => %w(de) },
    { :text => 'Organization'          , :label => :organization          , :code => 'o'  , :codes => %w(o) },
    { :text => 'Catalogs'              , :label => :catalogs              , :code => 'cl' , :codes => %w(cl) },
    { :text => 'Categories'            , :label => :categories            , :code => 'cg' , :codes => %w(cg) },
    { :text => 'Tags'                  , :label => :tags                  , :code => 'ta' , :codes => %w(ta) },
    { :text => 'Data Quality'          , :label => :data_quality          , :code => 'da' , :codes => %w(da0 da1) },
    { :text => 'Documentation Quality' , :label => :documentation_quality , :code => 'do' , :codes => %w(do0 do1) },
    { :text => 'Interestingness'       , :label => :interestingness       , :code => 'i'  , :codes => %w(i0 i1) },
    { :text => 'Period'                , :label => :period                , :code => 'p'  , :codes => %w(p0 p1) },
    { :text => 'Released'              , :label => :released              , :code => 're' , :codes => %w(re0 re1) },
    { :text => 'Updated'               , :label => :updated               , :code => 'u'  , :codes => %w(u0 u1) },
    { :text => 'Missing'               , :label => :missing               , :code => 'm'  , :codes => %w(m) },
    { :text => 'Distribution Format'   , :label => :distribution_format   , :code => 'df' , :codes => %w(df) },
    { :text => 'Distribution Kind'     , :label => :distribution_kind     , :code => 'dk' , :codes => %w(dk) },
  ]

  COLUMNS = [
    { :text => 'Title'                 , :label => :title                 , :code => 'ti' , :default => true  },
    { :text => 'Organization'          , :label => :organization          , :code => 'o'  , :default => true  },
    { :text => 'Catalogs'              , :label => :catalogs              , :code => 'cl' , :default => false },
    { :text => 'Categories'            , :label => :categories            , :code => 'cg' , :default => false },
    { :text => 'Tags'                  , :label => :tags                  , :code => 'ta' , :default => false },
    { :text => 'Data Quality'          , :label => :data_quality          , :code => 'da' , :default => true  },
    { :text => 'Documentation Quality' , :label => :documentation_quality , :code => 'do' , :default => false },
    { :text => 'Interestingness'       , :label => :interestingness       , :code => 'i'  , :default => false },
    { :text => 'Period'                , :label => :period                , :code => 'p'  , :default => false },
    { :text => 'Released'              , :label => :released              , :code => 're' , :default => false },
    { :text => 'Updated'               , :label => :updated               , :code => 'u'  , :default => false },
    { :text => 'Missing'               , :label => :missing               , :code => 'm'  , :default => false },
    { :text => 'Distributions'         , :label => :distributions         , :code => 'di' , :default => true  },
  ]

end
