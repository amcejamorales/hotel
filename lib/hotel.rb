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
end
