module DateConverter
  include RemainDay

  def changeToDate(deadline)
    return [nil, nil] unless valid_deadline_format?(deadline)
    
    year, month, day = parse_deadline(deadline)
    return [nil, nil] unless valid_date?(year, month, day)
    
    formatted_date = "#{year}/#{month}/#{day}"
    remaining_days = remainDay(year, month, day)
    
    [formatted_date, remaining_days]
  end

  private

  def valid_deadline_format?(deadline)
    deadline.to_s.length == 6 && deadline.to_s.match?(/^\d{6}$/)
  end

  def parse_deadline(deadline)
    deadline_str = deadline.to_s
    year = deadline_str[0, 2].to_i
    month = deadline_str[2, 2].to_i
    day = deadline_str[4, 2].to_i
    
    # Convert 2-digit year to 4-digit year
    year = year < 50 ? year + 2000 : year + 1900
    
    [year, month, day]
  end

  def valid_date?(year, month, day)
    return false if month < 1 || month > 12
    return false if day < 1 || day > 31
    
    begin
      Date.new(year, month, day)
      true
    rescue ArgumentError
      false
    end
  end
end
