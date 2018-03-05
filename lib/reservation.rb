module Hotel
  class Reservation

    COST_PER_NIGHT = 200.00

    attr_reader :room_number

    def initialize(start_date, end_date)
      @room_number = rand(21)
      @start_date = Date.parse(start_date)
      @end_date = Date.parse(end_date)

      if @start_date > @end_date
        raise StandardError.new("Invalid date range. Start date is after end date.")
      end
    end

    def reservation_length
      num_days = @end_date - @start_date
      num_days.to_i
    end

    def total_cost
      reservation_length * COST_PER_NIGHT
    end

  end # class Reservation
end # module Hotel
