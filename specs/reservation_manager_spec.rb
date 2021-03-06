require_relative 'spec_helper'
require 'pry'

describe Hotel::ReservationManager do
  before do
    COST_PER_NIGHT = 200.00
    @reservation_manager = Hotel::ReservationManager.new
    @guest = @reservation_manager.create_new_guest("Sam Jackson", "(610) 555-555", "1111-2222-3333-4444")
  end

  describe "#initialize" do
    it "can be created" do
      @reservation_manager.must_be_instance_of Hotel::ReservationManager
    end
  end # initialize

  describe "#generate_rooms" do
    before do
      @rooms_and_reservations = @reservation_manager.generate_rooms
    end

    it "returns an array of hashes of size 20" do
      @rooms_and_reservations.must_be_instance_of Array
      @rooms_and_reservations.length.must_equal 20
      @rooms_and_reservations.each do |room_info|
        room_info.must_be_instance_of Hash
      end
    end

    it "should have a hash for each item in the array with three keys and corresponding values" do
      room_number = 1
      @rooms_and_reservations.each do |room_info|
        room_info[:room_number].must_equal room_number
        room_info[:rate].must_equal 200.00
        room_info[:reservations].must_equal []

        room_number += 1
      end
    end
  end # rooms_and_reservations

  describe "#set_room_rate" do
    before do
      @rooms_and_reservations = @reservation_manager.rooms_and_reservations
    end
    it "returns a float value equal to the desired rate" do
      result = @reservation_manager.set_room_rate(1, 100.00)
      result.must_equal 100.00
    end

    it "allows the user to change the rate of any given room" do
      @rooms_and_reservations.each do |room_info|
        room_info[:rate].must_equal 200.00
      end
      @reservation_manager.set_room_rate(2, 150.00)
      @reservation_manager.set_room_rate(15, 210.00)
      room_two = @reservation_manager.find_room_info(2)
      room_fifteen = @reservation_manager.find_room_info(15)
      room_two[:rate].must_equal 150.00
      room_fifteen[:rate].must_equal 210.00
    end
  end # describe #set_room_rate

  describe "#view_rooms" do
    before do
      @rooms = @reservation_manager.view_rooms
    end
    it "returns an array" do
      @rooms.must_be_instance_of Array
    end

    it "returns an array of length 20, showing the room numbers from 1 to 20" do
      array_to_twenty = (1..20).map do |number|
        number
      end

      @rooms.size.must_equal 20

      @rooms.must_equal array_to_twenty
    end
  end # view_rooms

  describe "#create_new_guest" do
    it "returns a guest of type Guest" do
      @guest.must_be_instance_of Hotel::Guest
    end
    it "assigns the appropriate information to the new guest" do
      id = @reservation_manager.guests.length + 1
      name = "Sam Jackson"
      phone = "(610) 555-555"
      credit_card_number = "1111-2222-3333-4444"
      @guest.name.must_equal name
      @guest.phone.must_equal phone
      @guest.credit_card_number.must_equal credit_card_number
    end
  end # describe #create_new_guest

  describe "#generate_guest_id" do
    it "returns the length of the guests array plus one" do
      result = @reservation_manager.generate_guest_id
      result.must_equal 2
    end
  end # describe #generate_guest_id

  describe "#find_guest" do
    it "returns the guest entered if the guest exists in the guests array" do
      result = @reservation_manager.find_guest(@guest.id, @guest.name)
      result.must_equal @reservation_manager.guests.first
    end
    it "raises an error if the guest entered does not exist in the guests array" do
      new_guest = Hotel::Guest.new(2, "Tony Stark", "(708) 555-555", "5555-6666-7777-8888")
      result = proc { @reservation_manager.find_guest(new_guest.id, new_guest.name) }
      result.must_raise ArgumentError
    end
  end # describe #find_guest

  describe "#reserve_room" do

    before do
      @room_number = 1
      @start_date = Date.parse('2018-04-05')
      @end_date = Date.parse('2018-04-10')
    end

    it "returns the instance of Reservation created" do

      reservation = @reservation_manager.reserve_room(1, "2018-04-05", "2018-04-10", @guest)

      reservation.must_be_instance_of Hotel::Reservation
      reservation.room_number.must_equal @room_number
      reservation.start_date.must_equal @start_date
      reservation.end_date.must_equal @end_date
    end

    it "pushes the created reservation to the array corresponding to the room number in the rooms_and_reservations array" do
      room_one_info = @reservation_manager.find_room_info(1)
      room_one_reservations = room_one_info[:reservations]
      room_one_reservations.must_be_instance_of Array
      room_one_reservations.must_be_empty

      reservation = @reservation_manager.reserve_room(1, "2018-04-05", "2018-04-10", @guest)

      room_one_info = @reservation_manager.find_room_info(1)
      room_one_reservations = room_one_info[:reservations]
      room_one_reservations.must_be_instance_of Array
      room_one_reservations.length.must_equal 1

      room_one_reservation = room_one_reservations[0]

      room_one_reservation.must_be_instance_of Hotel::Reservation
      room_one_reservation.room_number.must_equal @room_number
      room_one_reservation.start_date.must_equal @start_date
      room_one_reservation.end_date.must_equal @end_date
    end

    it "allows you to get the total cost of a reservation" do
      num_nights = @end_date - @start_date
      total_cost = num_nights * COST_PER_NIGHT
      reservation = @reservation_manager.reserve_room(1, "2018-04-05", "2018-04-10", @guest)
      result = reservation.total_cost
      result.must_equal total_cost
    end

    it "lets you make overlapping reservations on the same room" do
      reservation_one = @reservation_manager.reserve_room(1, "2018-04-05", "2018-04-10", @guest)
      reservation_two = @reservation_manager.reserve_room(1, "2018-04-08", "2018-04-12", @guest)

      reservation_one.must_be_instance_of Hotel::Reservation
      reservation_two.must_be_instance_of Hotel::Reservation
      date_range_one = (reservation_one.start_date..reservation_one.end_date)
      date_range_two = (reservation_two.start_date..reservation_two.end_date)

      overlapping_dates = date_range_one.select do |date|
        date_range_two.include?(date)
      end

      overlapping_dates.wont_be_empty

    end

  end # reserve_room

  describe "#reservations_on" do
    it "returns an array" do
      reservations = @reservation_manager.reservations_on("2018-04-06")
      reservations.must_be_instance_of Array
    end

    it "returns an empty array if no reservations have been made" do
      reservations = @reservation_manager.reservations_on("2018-04-06")
      reservations.must_equal []
    end

    describe "#reservations_on accounts for completed reservations" do

      before do
        @reservation_manager.reserve_room(1, "2018-04-05", "2018-04-10", @guest)
        @reservation_manager.reserve_room(2, "2018-04-05", "2018-04-06", @guest)
        @date = Date.parse("2018-04-06")
        @reservations_on = @reservation_manager.reservations_on("2018-04-06")
      end

      it "the size of the array returned is equal to the number of reservations whose date ranges include the argument passed in" do
        @reservations_on.length.must_equal 2
      end

      it "each item in the array is an instance of Reservation" do
        @reservations_on.each do |reservation|
          reservation.must_be_instance_of Hotel::Reservation
        end
      end

      it "each reservation in the array has a date range that includes the argument passed in" do
        @reservations_on.each do |reservation|
          (reservation.start_date..reservation.end_date).must_include @date
        end
      end

      it "returns an empty array if no reservations include the argument passed in" do
        reservations_on = @reservation_manager.reservations_on("2018-04-25")
        reservations_on.must_equal []
      end

    end # describe reservations_on after reservations are made
  end # describe reservations_on

  describe "#view_available" do
    before do
      @available_rooms = @reservation_manager.view_available("2018-04-05", "2018-04-10")
    end

    it "returns an array" do
      @available_rooms.must_be_instance_of Array
    end

    it "returns an array of size 20 if no reservations have been made" do
      @available_rooms.length.must_equal 20
    end

    it "returns an empty array if all rooms are booked for the date range provided" do
      (1..20).each do |room|
        @reservation_manager.reserve_room(room, "2018-04-05", "2018-04-10", @guest)
      end
      result = @reservation_manager.view_available("2018-04-05", "2018-04-10")
      result.must_be_instance_of Array
      result.must_be_empty
      result = @reservation_manager.view_available("2018-04-01", "2018-04-06")
      result.must_be_instance_of Array
      result.must_be_empty
      result = @reservation_manager.view_available("2018-04-07", "2018-04-12")
      result.must_be_instance_of Array
      result.must_be_empty
    end

    it "returns an array of numbers" do
      @reservation_manager.reserve_room(1,"2018-04-05", "2018-04-10", @guest)
      available_rooms = @reservation_manager.view_available("2018-04-05", "2018-04-10")
      available_rooms.each do |room|
        room.must_be_instance_of Integer
      end
    end

    it "only includes the reservations which do not overlap with the date range provided" do
      available_rooms = (4..20).to_a

      @reservation_manager.reserve_room(1, "2018-04-03", "2018-04-08", @guest)
      @reservation_manager.reserve_room(2, "2018-04-04", "2018-04-09", @guest)
      @reservation_manager.reserve_room(3, "2018-04-05", "2018-04-10", @guest)
      @reservation_manager.reserve_room(4, "2018-04-06", "2018-04-11", @guest)
      @reservation_manager.reserve_room(5, "2018-04-07", "2018-04-12", @guest)

      result = @reservation_manager.view_available("2018-04-02", "2018-04-06")

      result.must_equal available_rooms

      available_rooms = (1..3).to_a + (6..20).to_a
      result = @reservation_manager.view_available("2018-04-10", "2018-04-12")
      result.must_equal available_rooms
    end

    it "excludes any rooms in a block" do
      @reservation_manager.generate_block(5, "2018-05-05", "2018-05-10", 150.00)
      available_rooms = (6..20).to_a
      result = @reservation_manager.view_available("2018-05-05", "2018-05-10")
      result.must_equal available_rooms
    end

  end # describe view_available

  describe "#reserve_available" do
    before do
      @reservation_manager.reserve_room(1, "2018-04-03", "2018-04-08", @guest)
      @reservation_manager.reserve_room(2, "2018-04-04", "2018-04-09", @guest)
      @reservation_manager.reserve_room(3, "2018-04-05", "2018-04-10", @guest)
      @reservation_manager.reserve_room(4, "2018-04-06", "2018-04-11", @guest)
      @reservation_manager.reserve_room(5, "2018-04-07", "2018-04-12", @guest)

      @available_rooms = @reservation_manager.view_available("2018-04-10", "2018-04-12")

      @result = @reservation_manager.reserve_available(1, "2018-04-10", "2018-04-12", @guest)
    end

    it "raises an error if no rooms are available" do
      (6..20).each do |room_num| @reservation_manager.reserve_available(room_num, "2018-04-03", "2018-04-12", @guest)
      end
      result = proc { @reservation_manager.reserve_available(2, "2018-04-03", "2018-04-12", @guest) }
      result.must_raise StandardError
    end

    it "returns the reservation created for the given date range" do
      first_available = @available_rooms[0]
      first_available.must_equal 1

      @result.must_be_instance_of Hotel::Reservation
      @result.room_number.must_equal first_available
    end

    it "creates a reservation for the selected room if it's available" do
      next_available = @available_rooms[1]

      next_available.must_equal 2

      result = @reservation_manager.reserve_available(next_available, "2018-04-10", "2018-04-12", @guest)
      result.room_number.must_equal next_available
    end

    it "raises an error if you try to reserve a room that has already been reserved for the date range provided" do
      result = proc { @reservation_manager.reserve_available(1, "2018-04-10", "2018-04-12", @guest) }
      result.must_raise StandardError
    end

    it "pushes the created reservation to the array corresponding to the selected room in the rooms_and_reservations array" do
      @available_rooms.first.must_equal 1

      first_room = @reservation_manager.find_room_info(1)

      first_room_reservations = first_room[:reservations]

      first_room_reservations.must_include @result
    end

    it "cannot reserve rooms inside of a block for the given date range" do
      available_rooms = (2..3).to_a + (6..20).to_a
      first_five_available_for_block = available_rooms[0..5]

      @reservation_manager.generate_block(5, "2018-04-10", "2018-04-12", 150.00)

      available_for_general_public = available_rooms[5..-1]
      room_number = available_rooms[5]
      public_reservation = @reservation_manager.reserve_available(room_number, "2018-04-10", "2018-04-12", @guest)
      public_reservation.room_number.must_equal available_for_general_public[0]
    end

  end # describe reserve_available

  describe "#generate_block" do
    before do
      @result = @reservation_manager.generate_block(5, "2018-05-05", "2018-05-10", 150.00)
    end

    it "returns an instance of block" do
      @result.must_be_instance_of Hotel::Block
    end

    it "pushes the first available rooms into the block's rooms array, as many as were requested" do
      next_available = (@reservation_manager.view_available("2018-05-05", "2018-05-10")).first
      @reservation_manager.reserve_available(next_available, "2018-05-05", "2018-05-10", @guest)
      available = @reservation_manager.view_available("2018-05-05", "2018-05-10")
      first_five_available = available[0...5]
      first_five_available.must_equal [7, 8, 9, 10, 11]
      result = @reservation_manager.generate_block(5, "2018-05-05", "2018-05-10", 150.00)
      result.rooms.must_equal first_five_available
    end

    it "pushes the newly created block to the reservation manager's list of blocks" do
      reservation_manager = Hotel::ReservationManager.new
      new_guest = reservation_manager.create_new_guest("Tony Stark", "(708) 555-555", "5555-6666-7777-8888")
      reservation_manager.reserve_available(1, "2018-05-05", "2018-05-10", new_guest)
      reservation_manager.blocks.must_be_empty

      result = reservation_manager.generate_block(5, "2018-05-05", "2018-05-10", 150.00)

      reservation_manager.blocks.size.must_equal 1

      reservation_manager.blocks.each do |block|
        block.must_be_instance_of Hotel::Block
      end
    end

    it "raises an error if there aren't enough available rooms for the number requested" do
      (1..18).each do |room|
        @reservation_manager.reserve_room(room, "2018-06-05", "2018-06-10", @guest)
      end
      NUM_BLOCKS = 1
      blocks_before = @reservation_manager.blocks
      blocks_before.size.must_equal NUM_BLOCKS

      block = proc { @reservation_manager.generate_block(3, "2018-06-05", "2018-06-10", 150.00) }

      block.must_raise StandardError

      blocks_after = @reservation_manager.blocks
      blocks_after.size.must_equal NUM_BLOCKS
    end

    it "does not allow a room in one block to be included in a different block for a given date range" do
      available_rooms = (6..20).to_a
      new_block = @reservation_manager.generate_block(5, "2018-05-05", "2018-05-10", 150.00)
      new_block.rooms.must_equal available_rooms[0...5]
    end
  end # describe #generate_block

  describe "#in_block?" do

    before do
      @reservation_manager.generate_block(5, "2018-04-04", "2018-04-11", 150.00)
    end

    it "returns a Boolean" do
      result = @reservation_manager.in_block?(1, "2018-03-05", "2018-03-10")
      result.must_be_instance_of FalseClass

      result = @reservation_manager.in_block?(1, "2018-04-05", "2018-04-10")
      result.must_be_instance_of TrueClass
    end

    it "returns true if a given room is in a block for a given date range" do
      result = @reservation_manager.in_block?(1, "2018-03-05", "2018-03-10")
      result.must_equal false
    end

    it "returns false if a given room is not in a block for a given date range" do
      result = @reservation_manager.in_block?(1, "2018-04-05", "2018-04-10")
      result.must_equal true
    end
  end # describe in_block?

  describe "#reserve_in_block" do
    before do
      @reservation_manager.generate_block(5, "2018-04-05", "2018-04-10", 150.00)
      @block = @reservation_manager.blocks[0]
      @block_id = @block.id
      @block_first_room = @block.rooms.first
    end

    it "returns an instance of  Reservation" do
      reservation = @reservation_manager.reserve_in_block(@block_id, @block_first_room, @guest)
      reservation.must_be_instance_of Hotel::Reservation
    end

    it "makes a reservation within a block" do
      room_info = @reservation_manager.find_room_info(@block_first_room)

      reservations = room_info[:reservations]

      reservations.length.must_equal 0

      @reservation_manager.reserve_in_block(@block_id, @block_first_room, @guest)

      reservations_after = room_info[:reservations]

      reservations_after.length.must_equal 1
    end

    it "raises an error if you try to reserve a room in a block that has already been reserved" do
      @reservation_manager.reserve_in_block(@block_id, @block_first_room, @guest)

      result  = proc { @reservation_manager.reserve_in_block(@block_id, @block_first_room, @guest) }

      result.must_raise StandardError
    end

    it "raises an error if there are no more available rooms in a block" do
      (1..5).each do |room_num|
        @reservation_manager.reserve_in_block(@block_id, room_num, @guest)
      end
      result = proc { @reservation_manager.reserve_in_block(@block_id, 1, @guest) }

      result.must_raise StandardError
    end

    it "properly assigns information from the block to the reservation" do
      num_nights = @block.end_date - @block.start_date
      total_cost = num_nights * @block.discount_rate

      reservation = @reservation_manager.reserve_in_block(@block_id, @block_first_room, @guest)

      reservation.room_number.must_equal @block.rooms[0]
      reservation.start_date.must_equal @block.start_date
      reservation.end_date.must_equal @block.end_date
      reservation.rate.must_equal @block.discount_rate
      reservation.total_cost.must_equal total_cost
    end
  end # describe reserve_in_block

  describe "#available_in_block" do
    before do
      @block_id = 1
      @reservation_manager.generate_block(5, "2018-04-05", "2018-04-10", 150.00)
      @reservation_manager.reserve_in_block(@block_id, 1, @guest)
      @result = @reservation_manager.available_in_block(@block_id)
    end

    it "returns an array of numbers" do
      @result.must_be_instance_of Array
      @result.each do |room|
        room.must_be_instance_of Integer
      end
    end

    it "returns only the rooms which haven't been reserved yet within a block" do
      available_in_block = (2..5).to_a

      @result.must_equal available_in_block
    end
  end # available_in_block

  describe "#reserved?" do
    before do
      @reservation_manager.reserve_room(1, "2018-04-05", "2018-04-10", @guest)
      @reservation_manager.reserve_room(1, "2018-06-05", "2018-06-10", @guest)
      @reserved = @reservation_manager.reserved?(1, "2018-04-05", "2018-04-10")
      @not_reserved = @reservation_manager.reserved?(1, "2018-05-05", "2018-05-10")
    end

    it "returns a Boolean" do
      @reserved.must_be_instance_of TrueClass
      result = @not_reserved.must_be_instance_of FalseClass
    end

    it "returns true if the room has a reservation for the date range provided" do
      @reserved.must_equal true
    end

    it "returns false if the room does not have a reservation for the date range provided" do
      @not_reserved.must_equal false
    end

    it "returns false if the room has no reservations" do
      result = @reservation_manager.reserved?(2, "2018-04-05", "2018-04-10")
    end
  end # describe #reserved

  describe "#find_block" do
    before do
      second_block_id = 2
      @reservation_manager.generate_block(5, "2018-04-05", "2018-04-10", 150.00)
      @reservation_manager.generate_block(3, "2018-05-05", "2018-05-10", 170.00)
      @block = @reservation_manager.find_block(second_block_id)
    end

    it "returns an instance of Block" do
      @block.must_be_instance_of Hotel::Block
    end

    it "returns the correct block" do
      block_id = 2
      available_rooms = (1..3).to_a
      start_date = Hotel::parse_date("2018-05-05")
      end_date = Hotel::parse_date("2018-05-10")
      discount_rate = 170.00

      @block.id.must_equal block_id
      @block.rooms.must_equal available_rooms
      @block.start_date.must_equal start_date
      @block.end_date.must_equal end_date
      @block.discount_rate.must_equal discount_rate
    end

    it "raises an error if the block does not exist" do
      nonexistent_block_id = 5
      result = proc { @reservation_manager.find_block(nonexistent_block_id) }
      result.must_raise ArgumentError
    end

  end # describe #find_block

end # describe ReservationManager
