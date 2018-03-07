require_relative 'reservation_manager'

module Hotel

  class Block

    def initialize(num_rooms, start_date, end_date, discount_rate)
      @num_rooms = num_rooms
      @start_date = start_date
      @end_date = end_date
      @discount_rate = discount_rate
      @block = generate_block

      if num_rooms > 5
        raise ArgumentError.new("Error: cannot set aside more than 5 rooms in a block.")
      end
    end

  end # class Block

end # module Hotel
