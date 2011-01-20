module Validators

  # if not blank, expect an integer
  def expect_integer(value, field, subfield)
    return true if value.blank?
    return true if value.is_a?(Integer)
    errors.add(field, "#{subfield} must be an integer if present")
    false
  end

  # if not blank, expect a float
  def expect_float(value, field, subfield)
    return true if value.blank?
    return true if value.is_a?(Float)
    errors.add(field, "#{subfield} must be a float if present")
    false
  end

  # if not blank, expect an integer or float
  def expect_integer_or_float(value, field, subfield)
    return true if value.blank?
    return true if value.is_a?(Integer) || value.is_a?(Float)
    errors.add(field, "#{subfield} must be an integer or float if present")
    false
  end

  # if not blank, expect an array
  def expect_array(value, field, subfield)
    return true if value.blank?
    return true if value.is_a?(Array)
    errors.add(field, "#{subfield} must be an array")
    false
  end

  # if not blank, expect an array of integers
  def expect_array_of_integers(value, field, subfield)
    return false unless expect_array(value, field, subfield)
    error_count = 0
    value.each_with_index do |v, i|
      error_count += 1 unless expect_integer(v, field, "#{subfield}[#{i}]")
    end
    error_count == 0
  end

  # if not blank, expect a Kronos hash
  def expect_kronos_hash(value, field)
    return true if value.blank?
    if (value.keys - %w(year month day)).length > 0
      errors.add(field, "only 'year', 'month', and 'day' keys are allowed")
      return false
    end
    year, month, day = value['year'], value['month'], value['day']
    error_count = 0
    error_count += 1 unless expect_integer(year,  field, :year)
    error_count += 1 unless expect_integer(month, field, :month)
    error_count += 1 unless expect_integer(day,   field, :day)
    return false unless error_count == 0
    kronos = new_kronos(year, month, day)
    kronos_errors = kronos.errors
    kronos_errors.each { |e| errors.add(field, e) }
    kronos_errors.empty?
  end

  # if not blank, expect a ratings hash
  def expect_ratings_hash(value, field)
    return true if value.blank?
    if (value.keys - %w(avg min max bins)).length > 0
      errors.add(field, "only 'min', 'max', 'avg', and 'bins' keys are allowed")
      return false
    end
    min, max, avg, bins = value['min'], value['max'], value['avg'], value['bins']
    error_count = 0
    error_count += 1 unless expect_integer(min, field, :min)
    error_count += 1 unless expect_integer(max, field, :max)
    error_count += 1 unless expect_integer_or_float(avg, field, :avg)
    error_count += 1 unless expect_array_of_integers(bins, field, :bins)
    error_count == 0
  end

  def new_kronos(year=nil, month=nil, day=nil)
    k = Kronos.new
    k.year  = year if year
    k.month = month if month
    k.day   = day if day
    k
  end

end
