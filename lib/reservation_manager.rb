require_relative 'reservation'

module Hotel
  class ReservationManager
    def initialize
    end # initialize

    def rooms_and_reservations
      rooms_and_reservations = {}
      20.times do |room|
        rooms_and_reservations[room + 1] = []
      end
      rooms_and_reservations
    end

  end # class ReservationManager
end # module Hotel
