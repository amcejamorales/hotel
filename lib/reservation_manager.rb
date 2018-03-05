require_relative 'reservation'

module Hotel
  class ReservationManager

    attr_reader :rooms_and_reservations

    def initialize
      @rooms_and_reservations = rooms_and_reservations
    end # initialize

    def rooms_and_reservations
      rooms_and_reservations = {}
      20.times do |room|
        rooms_and_reservations[room + 1] = []
      end
      rooms_and_reservations
    end

    def view_rooms
      rooms = @rooms_and_reservations.keys
    end

    def reserve_room(room_num, start_date, end_date)
      check_room_num(room_num)
    end

    def check_room_num(room_num)
      if !/^\d+$/.match(room_num.to_s)
        raise ArgumentError.new("Invalid room number input. Please enter a number from 1 to 20.")
      end
      if !(1..20).include?(room_num)
        raise ArgumentError.new("Invalid room number input. Room #{room_num} does not exist.")
      end
    end

  end # class ReservationManager
end # module Hotel
