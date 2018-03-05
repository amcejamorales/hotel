require_relative 'reservation'

module Hotel
  class ReservationManager

    attr_reader :rooms_and_reservations

    def initialize
      @rooms_and_reservations = generate_rooms
    end # initialize

    def generate_rooms
      rooms_and_reservations = {}
      20.times do |room|
        rooms_and_reservations[room + 1] = Array.new()
      end
      rooms_and_reservations
    end

    def view_rooms
      rooms = @rooms_and_reservations.keys
    end

    def reserve_room(room_num, start_date, end_date)
      new_reservation = Reservation.new(room_num, start_date, end_date)
      @rooms_and_reservations[room_num] << new_reservation
      new_reservation
    end

  end # class ReservationManager
end # module Hotel
