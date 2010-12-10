module Validators

  def expect_integer(x, field, subfield)
    return if x.blank?
    unless x.is_a?(Integer)
      errors.add(field, "#{subfield} must be an integer if present")
    end
  end

  def expect_kronos_hash(x, field)
    return if x.blank?
    if (x.keys - %w(year month day)).length > 0
      errors.add(field, "only 'year', 'month', and 'day' keys are allowed")
      return
    end
    year, month, day = x['year'], x['month'], x['day']
    expect_integer(year,  field, :year)
    expect_integer(month, field, :month)
    expect_integer(day,   field, :day)
    kronos = new_kronos(year, month, day)
    kronos.errors.each { |e| errors.add(field, e) }
  end

  def new_kronos(year=nil, month=nil, day=nil)
    k = Kronos.new
    k.year  = year if year
    k.month = month if month
    k.day   = day if day
    k
  end

end
