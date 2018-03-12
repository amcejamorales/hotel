require_relative 'reservation'
require_relative 'block'
require_relative 'guest'
require 'pry'
require 'date'

module Hotel
  class ReservationManager

    attr_reader :rooms_and_reservations, :blocks, :guests

    def initialize
      @rooms_and_reservations = generate_rooms
      @blocks = []
      @guests = []
    end # initialize

    def generate_rooms
      rooms_and_reservations = []
      (1..20).each do |room|
        room_info = {
          room_number: room,
          rate: 200.00,
          reservations: []
        }
        rooms_and_reservations << room_info
      end
      rooms_and_reservations
    end # generate_rooms

    def set_room_rate(room_number, rate)
      room = @rooms_and_reservations.select { |room_info|
        room_info[:room_number] == room_number
      }.first

      room[:rate] = rate
      rate
    end # set_room_rate

    def view_rooms
      rooms = @rooms_and_reservations.map do |room_info|
        room_info[:room_number]
      end
    end # view_rooms

    def create_new_guest(name, phone, credit_card_number)
      id = generate_guest_id
      new_guest = Hotel::Guest.new(id, name, phone, credit_card_number)
      @guests << new_guest
      new_guest
    end # create_new_guest

    def generate_guest_id
      @guests.length + 1
    end # generate_guest_id

    def find_guest(guest_id, guest_name)
      found_guest = @guests.select { |guest_info|
        guest_info.id == guest_id
        guest_info.name == guest_name
      }.first
      if found_guest.nil?
        raise ArgumentError.new("Guest #{guest_name} does not exist in our records.")
      end
      found_guest
    end # find_guest

    def reserve_room(room_num, start_date, end_date, guest, rate = 200.00)
      Hotel::valid_date_range(start_date, end_date)
      room_info = find_room_info(room_num)
      room_rate = room_info[:rate]

      if rate == 200.00
        rate = room_rate
      elsif rate != 200.00
        rate = [rate, room_rate].min
      end

      new_reservation = Reservation.new(room_num, start_date, end_date, guest, rate)

      new_guest = !find_guest(guest.id, guest.name)
      @guests << guest if new_guest

      room_info[:reservations] << new_reservation

      new_reservation
    end # reserve_room

    def find_room_info(room_number)
      room_info = @rooms_and_reservations.select { |room_info|
        room_info[:room_number] == room_number
      }.first
      room_info
    end # find_room_info

    def reservations_on(date_string)
      date = Hotel::parse_date(date_string)
      reservations_on_date = []
      @rooms_and_reservations.each do |room, reservations|
        # possible to do an optional argument of end_date = start_date? in reserved?
        overlap = reserved?(room[:room_number], date, date)
        reservations = room[:reservations]
        reservations.each do |reservation|
          reservations_on_date << reservation if overlap
        end
      end
      reservations_on_date
    end # reservations_on

    def view_available(start_date, end_date)
      unavailable = []

      @rooms_and_reservations.each do |room , reservations|
        unavailable << room[:room_number] if in_block?(room[:room_number], start_date, end_date)

        overlap = reserved?(room[:room_number], start_date, end_date)
        unavailable << room[:room_number] if overlap
      end

      available_rooms = view_rooms

      available_rooms.select! do |room|
        !unavailable.include?(room)
      end

      available_rooms
    end # def view_available

    def reserve_available(start_date, end_date, guest)
      available_rooms = view_available(start_date, end_date)

      if available_rooms.empty?
        raise StandardError.new("There are no rooms available between #{start_date} and #{end_date}")
      end

      first_available = available_rooms.first

      new_reservation = reserve_room(first_available, start_date, end_date, guest)
    end

    def generate_block(num_rooms, start_date, end_date, discount_rate)
      block_id = generate_block_id
      block = Hotel::Block.new(block_id, num_rooms, start_date, end_date, discount_rate)

      # binding.pry

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

    def in_block?(room, start_date, end_date)
      in_block = false
      @blocks.each do |block|
        overlap = Hotel::overlap?(start_date, end_date, block.start_date, block.end_date)
        if overlap && block.rooms.include?(room)
          in_block = true
        end
      end
      in_block
    end # in_block?

    def reserve_in_block(block_id, guest)
      block = find_block(block_id)
      available = available_in_block(block_id)

      if available.empty?
        raise StandardError.new("There are no more rooms available in block #{block_id}.")
      end

      reservation = reserve_room(available[0], block.start_date, block.end_date,
      guest,
      block.discount_rate)
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
      room_info = find_room_info(room_number)
      room_reservations = room_info[:reservations]
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
