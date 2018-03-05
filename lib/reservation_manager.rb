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

  end # class ReservationManager
end # module Hotel
