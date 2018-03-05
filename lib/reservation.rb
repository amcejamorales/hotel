module Hotel
  class Reservation

    attr_reader :room_number

    def initialize(start_date, end_date)
      @room_number = rand(21)
      @start_date = Date.parse(start_date)
      @end_date = Date.parse(end_date)

      if @start_date > @end_date
        raise StandardError.new("Invalid date range. Start date is after end date.")
      end
    end

  end # class Reservation
end # module Hotel