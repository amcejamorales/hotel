module Hotel
  def self.overlap?(first_start_date, first_end_date, second_start_date, second_end_date)
    first_start_date = parse_date(first_start_date)
    first_end_date = parse_date(first_end_date)
    second_start_date = parse_date(second_start_date)
    second_end_date = parse_date(second_end_date)

    overlap = false

    if first_start_date < second_start_date
      if first_end_date > second_start_date
        overlap = true
      end
      if first_end_date == second_start_date && second_start_date == second_end_date
        overlap = true
      end
    elsif first_start_date > second_start_date
      if first_start_date < second_end_date
        overlap = true
      end
      if first_start_date == second_end_date && first_start_date == first_end_date
        overlap = true
      end
    elsif first_start_date == second_start_date
      overlap = true
    end
    overlap
  end # overlap?

  def self.parse_date(date)
    date = Date.parse(date) if date.is_a?(String)
    date
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
