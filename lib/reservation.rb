module Hotel
  class Reservation

    # COST_PER_NIGHT = 200.00

    attr_reader :room_number, :start_date, :end_date, :rate

    def initialize(room_number, start_date, end_date, guest, rate = 200.00)
      check_room_num(room_number)
      @room_number = room_number
      @start_date = Hotel::parse_date(start_date)
      @end_date = Hotel::parse_date(end_date)

      Hotel::valid_date_range(start_date, end_date)
      @guest = guest
      @rate = rate
    end

    def reservation_length
      num_days = @end_date - @start_date
      num_days.to_i
    end

    def total_cost
      reservation_length * @rate
    end

    def check_room_num(room_num)
      if !/^\d+$/.match(room_num.to_s)
        raise ArgumentError.new("Invalid room number input. Please enter a number from 1 to 20.")
      end
      if !(1..20).include?(room_num)
        raise ArgumentError.new("Invalid room number input. Room #{room_num} does not exist.")
      end
    end

    def adjust_rate_if_needed(rate_from_arguments, room_rate)
      if rate_from_arguments == 200.00
        @rate = room_rate
      elsif rate_from_arguments != 200.00
        @rate = [rate_from_arguments, room_rate].min
      end
      return @rate
    end

  end # class Reservation
end # module Hotel
