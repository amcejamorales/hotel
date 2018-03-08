module Hotel
  def self.overlap?(first_start_date, first_end_date, second_start_date, second_end_date)
    first_start = parse_date(first_start_date)
    first_end = parse_date(first_end_date)
    second_start = parse_date(second_start_date)
    second_end = parse_date(second_end_date)

    overlap = false

    if first_start < second_start
      if first_end > second_start
        overlap = true
      end
    elsif first_start > second_start
      if first_start < second_end
        overlap = true
      end
    elsif first_start == second_start
      overlap = true
    end
    overlap
  end # overlap?

  def self.parse_date(date_string)
    Date.parse(date_string)
  end # parse_date

  def self.valid_date_range(start_string, end_string)
    start_date = parse_date(start_string)
    end_date = parse_date(end_string)

    if end_date < start_date
      raise ArgumentError.new("Invalid date range. End date comes before start date.")
    end
    true
  end # valid_date_range
end
