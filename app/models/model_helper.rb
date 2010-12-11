class ModelHelper

  def self.find_duplicate(model, params, attribute_list)
    query_attributes = {}
    attribute_list.each do |attribute|
      unless attribute.is_a?(Symbol)
        raise "Attribute #{attribute.inspect} must be a symbol"
      end
      value = params[attribute] || params[attribute.to_s]
      # There are valid cases where value can be nil
      query_attributes[attribute] = value
    end
    matches = model.where(query_attributes)
    case matches.length
    when 0 then nil
    when 1 then matches.first
    else raise "2+ #{model} matches for #{query_attributes.inspect}"
    end
  end

  def self.ensure(model, attributes)
    match = find_duplicate(model, attributes)
    if match
      puts "- Found #{model}..."
      match.update_attributes!(attributes)
    else
      puts "- Creating #{model}..."
      model.create!(attributes)
    end
  end

end
