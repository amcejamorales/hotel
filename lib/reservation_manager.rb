require_relative 'reservation'
require 'pry'
require 'date'

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

    def reservations_on(date_string)
      date = Date.parse(date_string)
      reservations_on_date = []
      @rooms_and_reservations.each do |room, reservations|
        reservations.each do  |reservation|
          date_range = (reservation.start_date..reservation.end_date)
          if date_range.include?(date)
            reservations_on_date << reservation
          end
        end
      end
      reservations_on_date
    end # reservations_on

    def view_available(start_date, end_date)
      room_reservations = []
      date_range = (start_date..end_date)

      @rooms_and_reservations.each do |room, reservations|
        reservations.each do  |reservation|
          overlap = false
          room_date_range = (reservation.start_date..reservation.end_date)
          date_range.each do |date|
            if room_date_range.include?(Date.parse(date))
              overlap = true
            end
          end
          room_reservations << room if overlap
        end
      end

      available_rooms = view_rooms

      available_rooms = available_rooms.select do |room|
        !room_reservations.include?(room)
      end

      available_rooms
    end # def view_available

    def reserve_available(start_date, end_date)
      available_rooms = view_available(start_date, end_date)
      first_available = available_rooms.first

      new_reservation = Hotel::Reservation.new(first_available, start_date, end_date)

      @rooms_and_reservations[first_available] << new_reservation
      new_reservation
    end

  end # class ReservationManager
end # module Hotel
