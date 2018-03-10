module Hotel

  class Block

    attr_reader :id, :num_rooms, :start_date, :end_date, :discount_rate

    attr_accessor :rooms

    def initialize(id, num_rooms, start_date, end_date, discount_rate)
      @id = id
      @num_rooms = num_rooms
      @start_date = start_date
      @end_date = end_date
      @discount_rate = discount_rate
      @rooms = []

      if num_rooms > 5
        raise ArgumentError.new("Error: cannot set aside more than 5 rooms in a block.")
      end
    end

  end # class Block

end # module Hotel
