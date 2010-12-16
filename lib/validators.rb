module Validators

  def expect_integer(value, field, subfield)
    return if value.blank?
    return true if value.is_a?(Integer)
    errors.add(field, "#{subfield} must be an integer if present")
    false
  end

  def expect_float(value, field, subfield)
    return if value.blank?
    return true if value.is_a?(Float)
    errors.add(field, "#{subfield} must be a float if present")
    false
  end

  def expect_integer_or_float(value, field, subfield)
    return if value.blank?
    return true if value.is_a?(Integer) || value.is_a?(Float)
    errors.add(field, "#{subfield} must be an integer or float if present")
    false
  end

  def expect_array(value, field, subfield)
    return if value.blank?
    return true if value.is_a?(Array)
    errors.add(field, "#{subfield} must be an array")
    false
  end

  def expect_array_of_integers(value, field, subfield)
    return unless expect_array(value, field, subfield)
    error_count = 0
    value.each_with_index do |v, i|
      unless expect_integer(v, field, "#{subfield}[#{i}]")
        error_count += 1
      end
    end
    error_count == 0
  end

  def expect_kronos_hash(value, field)
    return if value.blank?
    if (value.keys - %w(year month day)).length > 0
      errors.add(field, "only 'year', 'month', and 'day' keys are allowed")
      return
    end
    year, month, day = value['year'], value['month'], value['day']
    expect_integer(year,  field, :year)
    expect_integer(month, field, :month)
    expect_integer(day,   field, :day)
    kronos = new_kronos(year, month, day)
    kronos.errors.each { |e| errors.add(field, e) }
  end

  def expect_ratings_hash(value, field)
    return if value.blank?
    if (value.keys - %w(avg min max bins)).length > 0
      errors.add(field, "only 'min', 'max', 'avg', and 'bins' keys are allowed")
      return
    end
    min, max, avg, bins = value['min'], value['max'], value['avg'], value['bins']
    expect_integer(min, field, :min)
    expect_integer(max, field, :max)
    expect_integer_or_float(avg, field, :avg)
    expect_array_of_integers(bins, field, :bins)
  end

  def new_kronos(year=nil, month=nil, day=nil)
    k = Kronos.new
    k.year  = year if year
    k.month = month if month
    k.day   = day if day
    k
  end

end
