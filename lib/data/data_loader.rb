class DataLoader

  # Models have associations, so construct models in an order that makes
  # sense for building up the associations.
  MODELS = [
    { :constant => Location,           :name => :locations },
    { :constant => Organization,       :name => :organizations },
    { :constant => Catalog,            :name => :catalogs },
    { :constant => Site,               :name => :sites },
    { :constant => Label,              :name => :labels },
    { :constant => User,               :name => :users },
    { :constant => Category,           :name => :categories },
    { :constant => DataSet,            :name => :data_sets },
    { :constant => FeaturedDataSet,    :name => :featured_data_sets },
    { :constant => Tag,                :name => :tags },
    { :constant => Activity,           :name => :activities },
  ]

  def initialize(options)
    @models     = options[:models] || MODELS
    @model_path = options[:model_path] || '.'
    @verbosity  = options[:verbosity] || 0
  end

  def run
    @models.each do |model|
      filename = File.join(@model_path, "#{model[:name]}.yml")
      if File.exist?(filename)
        process_file(filename, model)
      end
    end
    self
  end

  protected

  # Process one YAML file, which may contain multiple documents.
  def process_file(filename, model)
    puts "Loading #{filename}" if @verbosity >= 1
    File.open(filename) do |file|
      YAML.load_documents(file) do |document|
        process_document(document, model)
      end
    end
  end

  # Process one YAML document.
  def process_document(document, model)
    case document
    when Array
      process_array(document, model)
    else
      raise "Unexpected document class: #{document.class}"
    end
  end

  # Process a YAML document that is an array.
  def process_array(array, model)
    array.each do |fields|
      self.ensure(model[:constant], fields)
    end
  end

  def ensure(model, attributes)
    puts "- ensure(#{model}, #{attributes.inspect})" if @verbosity >= 3
    object = model.find_duplicate(attributes)
    if object
      puts "  - updating duplicate: #{object}" if @verbosity >= 3
    else
      object = model.new
      puts "  - creating document: #{object}..." if @verbosity >= 3
    end
    set_fields(object, attributes)
    object.save!
    object
  end

  def set_fields(object, attributes)
    attributes.each do |field, value_or_reference|
      value = transform(value_or_reference)
      assign_field(object, field, value)
    end
  end

  # Most of the time, a simple assignment works. But in the case of
  # embedded objects, we have to call `build`.
  def assign_field(object, field, value)
    if @verbosity == 2
      display = if value.is_a?(Array)
        "[ ... ]"
      elsif value.is_a?(Hash)
        "{ ... }"
      else
        value.to_s
      end
      puts "- #{field} : #{display}"
    end
    puts "- #{field} : #{value.inspect}" if @verbosity == 3
    if embedded?(object, field)
      build_it(object, field, value)
    else
      object.send("#{field}=", value)
    end
  end

  def embedded?(object, field)
    metadata = object.relations[field]
    metadata && metadata.embedded?
  end

  def build_it(object, field, value_or_values)
    if value_or_values.is_a?(Array)
      # From http://mongoid.org/docs/associations/
      # person.phone_numbers = [ Phone.new(:number => "415-555-1212") ]
      klass = object.relations[field].klass
      object.send("#{field}=", value_or_values.map { |v| klass.new(v) })
    else
      # From http://mongoid.org/docs/associations/
      # person.phone_numbers.build(:number => "415-555-1212")
      object.send(field).build(value_or_values)
    end
  end

  # Recursively search for symbols and convert them to the objects that
  # they reference.
  def transform(value_or_reference)
    if value_or_reference.is_a?(NilClass)
      value_or_reference
    elsif value_or_reference.is_a?(TrueClass)
      value_or_reference
    elsif value_or_reference.is_a?(FalseClass)
      value_or_reference
    elsif value_or_reference.is_a?(String)
      value_or_reference
    elsif value_or_reference.is_a?(Array)
      value_or_reference.map { |x| transform(x) }
    elsif value_or_reference.is_a?(Hash)
      transform_hash(value_or_reference)
    else
      raise "Unsupported value: #{value_or_reference.inspect}. " +
        "Class: #{value_or_reference.class}"
    end
  end

  def transform_hash(hash)
    case hash.keys.count { |x| x.is_a?(Symbol) }
    when 0
      hash
    when 1
      unless hash.keys.count == 1
        raise "Unsupported reference: #{hash.inspect}"
      end
      lookup_reference!(hash.keys.first, hash.values.first)
    else
      raise "Unsupported reference: #{hash.inspect}"
    end
  end

  # Lookup an object using a symbol.
  def lookup_reference!(key, value)
    puts "  - Looking up #{key.inspect} #{value.inspect}" if @verbosity >= 4
    model = key.to_s.camelize.constantize
    documents = model.where(value)
    unless documents.length == 1
      raise "#{model}.where(#{value.inspect}) returned " +
        "#{documents.length} documents."
    end
    documents.first
  end

end
