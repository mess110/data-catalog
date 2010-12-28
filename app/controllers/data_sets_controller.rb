class DataSetsController < ApplicationController

  def index
    @data_sets = DataSet.top_level
    advanced_search_setup
  end

  def show
    @data_set = DataSet.where(:slug => params[:id]).first
    render_404 && return unless @data_set
  end

  def new
  end

  def create
  end

  def custom_search
    filters = get_active_filters
    columns = get_columns_array
    new_params = make_new_params(params, filters, columns)
    redirect_to({ :action => :index }.merge(new_params))
  end

  protected

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
  def make_new_params(params, filters, columns)
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

  def advanced_search_setup
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
    @representation_kinds = %w(API document tool).map { |f| [f, f] }
    @representation_formats = %w(CSV JSON RDF XLS XML).map { |f| [f, f] }
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
    { :text => 'Representation Format' , :label => :representation_format , :code => 'rf' , :codes => %w(rf) },
    { :text => 'Representation Kind'   , :label => :representation_kind   , :code => 'rk' , :codes => %w(rk) },
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
    { :text => 'Representations'       , :label => :representations       , :code => 'rp' , :default => true  },
  ]

end
