require_relative 'reservation'
require_relative 'block'
require 'pry'
require 'date'

module Hotel
  class ReservationManager

    attr_reader :rooms_and_reservations, :blocks

    def initialize
      @rooms_and_reservations = generate_rooms
      @blocks = []
    end # initialize

    def generate_rooms
      rooms_and_reservations = {}
      20.times do |room|
        rooms_and_reservations[room + 1] = Array.new()
      end
      rooms_and_reservations
    end # generate_rooms

    def view_rooms
      rooms = @rooms_and_reservations.keys
    end # view_rooms

    def reserve_room(room_num, start_date, end_date, rate = 200.00)
      Hotel::valid_date_range(start_date, end_date)
      new_reservation = Reservation.new(room_num, start_date, end_date, rate)
      @rooms_and_reservations[room_num] << new_reservation
      new_reservation
    end # reserve_room

    def reservations_on(date_string)
      date = Hotel::parse_date(date_string)
      reservations_on_date = []
      @rooms_and_reservations.each do |room, reservations|
        reservations.each do  |reservation|
          overlap = Hotel::overlap?(date, date, reservation.start_date, reservation.end_date)

          if overlap
            reservations_on_date << reservation
          end
        end
      end
      reservations_on_date
    end # reservations_on

    def view_available(start_date, end_date)
      unavailable = []

      @rooms_and_reservations.each do |room , reservations|
        unavailable << room if in_block?(room, start_date, end_date)
        overlap = reserved?(room, start_date, end_date)
        unavailable << room if overlap
      end

      available_rooms = view_rooms

      available_rooms = available_rooms.select do |room|
        !unavailable.include?(room)
      end

      available_rooms
    end # def view_available

    def reserve_available(start_date, end_date)
      available_rooms = view_available(start_date, end_date)

      if available_rooms.empty?
        raise StandardError.new("There are no rooms available between #{start_date} and #{end_date}")
      end

      first_available = available_rooms.first

      new_reservation = reserve_room(first_available, start_date, end_date)
    end

    def generate_block(num_rooms, start_date, end_date, discount_rate)
      block_id = generate_block_id
      block = Hotel::Block.new(block_id, num_rooms, start_date, end_date, discount_rate)

      available_rooms = view_available(start_date, end_date)

      if num_rooms > available_rooms.length
        raise StandardError.new("There aren't enough rooms to create a block between #{start_date} and #{end_date}.")
      end

      available_rooms[0...num_rooms].each do |room|
        block.rooms << room
      end

      @blocks << block

      block
    end # generate_block

    def generate_block_id
      @blocks.length + 1
    end

    def in_block?(room_num, start_date, end_date)
      in_block = false
      @blocks.each do |block|
        overlap = Hotel::overlap?(start_date, end_date, block.start_date, block.end_date)
        if overlap && block.rooms.include?(room_num)
          in_block = true
        end
      end
      in_block
    end # in_block?

    def reserve_in_block(block_id)
      block = find_block(block_id)
      available = available_in_block(block_id)

      if available.empty?
        raise StandardError.new("There are no more rooms available in block #{block_id}.")
      end

      reservation = reserve_room(available[0], block.start_date, block.end_date, block.discount_rate)
      reservation
    end # reserve_in_block

    def available_in_block(block_id)
      block = find_block(block_id)
      available = []
      block.rooms.each do |room|
        reserved = reserved?(room, block.start_date, block.end_date)
        available << room if !reserved
      end
      available
    end # available_in_block

    def reserved?(room_number, start_date, end_date)
      room_reservations = @rooms_and_reservations[room_number]
      overlap = false
      room_reservations.each do |reservation|
        overlap = Hotel::overlap?(start_date, end_date, reservation.start_date, reservation.end_date)
        return overlap if overlap
      end
      overlap
    end # reserved

    def find_block(block_id)
      block_ids = @blocks.map do |block|
        block.id
      end
      if !block_ids.include?(block_id)
        raise ArgumentError.new("Block #{block_id} does not exist.")
      end

      @blocks.select { |block| block.id == block_id }.first
    end # find_block

  end # class ReservationManager
end # module Hotel
