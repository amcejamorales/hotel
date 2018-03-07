require_relative 'spec_helper'
require 'pry'

describe Hotel::ReservationManager do
  before do
    COST_PER_NIGHT = 200.00
    @reservation_manager = Hotel::ReservationManager.new
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

    it "returns a hash" do
      @rooms_and_reservations.must_be_instance_of Hash
    end

    it "returns a hash of length 20, for which every key is a number from 1 to 20" do
      array_to_twenty = (1..20).map do |number|
        number
      end
      @rooms_and_reservations.size.must_equal 20
      @rooms_and_reservations.keys.must_equal array_to_twenty
    end

    it "returns a hash for which every value is an empty array upon creation of ReservationManager" do
      @rooms_and_reservations.each do |room, reservations|
        reservations.must_equal []
      end
    end
  end # rooms_and_reservations

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

  describe "#reserve_room" do

    before do
      @room_number = 1
      @start_date = Date.parse('2018-04-05')
      @end_date = Date.parse('2018-04-10')
    end

    it "returns the instance of Reservation created" do

      reservation = @reservation_manager.reserve_room(1, "2018-04-05", "2018-04-10")

      reservation.must_be_instance_of Hotel::Reservation
      reservation.room_number.must_equal @room_number
      reservation.start_date.must_equal @start_date
      reservation.end_date.must_equal @end_date
    end

    it "pushes the created reservation to the array corresponding to the room number in the rooms_and_reservations hash" do
      room_one_reservations = @reservation_manager.rooms_and_reservations[1]
      room_one_reservations.must_be_instance_of Array
      room_one_reservations.must_be_empty

      reservation = @reservation_manager.reserve_room(1, "2018-04-05", "2018-04-10")

      room_one_reservations = @reservation_manager.rooms_and_reservations[1]
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
      reservation = @reservation_manager.reserve_room(1, "2018-04-05", "2018-04-10")
      result = reservation.total_cost
      result.must_equal total_cost
    end

    it "lets you make overlapping reservations on the same room" do
      reservation_one = @reservation_manager.reserve_room(1, "2018-04-05", "2018-04-10")
      reservation_two = @reservation_manager.reserve_room(1, "2018-04-08", "2018-04-12")

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

    describe "#reservations_on accounst for completed reservations" do

      before do
        @reservation_manager.reserve_room(1, "2018-04-05", "2018-04-10")
        @reservation_manager.reserve_room(1, "2018-04-05", "2018-04-06")
        @reservations_on = @reservation_manager.reservations_on("2018-04-06")
        @date = Date.parse("2018-04-06")
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
        @reservation_manager.reserve_room(room, "2018-04-05", "2018-04-10")
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
      @reservation_manager.reserve_room(1,"2018-04-05", "2018-04-10")
      available_rooms = @reservation_manager.view_available("2018-04-05", "2018-04-10")
      available_rooms.each do |room|
        room.must_be_instance_of Integer
      end
    end

    it "only includes the reservations which do not overlap with the date range provided" do
      available_rooms = (4..20).to_a

      @reservation_manager.reserve_room(1, "2018-04-03", "2018-04-08")
      @reservation_manager.reserve_room(2, "2018-04-04", "2018-04-09")
      @reservation_manager.reserve_room(3, "2018-04-05", "2018-04-10")
      @reservation_manager.reserve_room(4, "2018-04-06", "2018-04-11")
      @reservation_manager.reserve_room(5, "2018-04-07", "2018-04-12")

      result = @reservation_manager.view_available("2018-04-02", "2018-04-05")

      result.must_equal available_rooms

      available_rooms = (1..3).to_a + (6..20).to_a
      result = @reservation_manager.view_available("2018-04-11", "2018-04-12")
      result.must_equal available_rooms
    end
  end # describe view_available

  describe "#reserve_available" do
    before do
      @reservation_manager.reserve_room(1, "2018-04-03", "2018-04-08")
      @reservation_manager.reserve_room(2, "2018-04-04", "2018-04-09")
      @reservation_manager.reserve_room(3, "2018-04-05", "2018-04-10")
      @reservation_manager.reserve_room(4, "2018-04-06", "2018-04-11")
      @reservation_manager.reserve_room(5, "2018-04-07", "2018-04-12")

      @available_rooms = @reservation_manager.view_available("2018-04-11", "2018-04-12")

      @result = @reservation_manager.reserve_available("2018-04-11", "2018-04-12")
    end

    it "returns the reservation created for the given date range" do
      first_available = @available_rooms[0]
      first_available.must_equal 1

      @result.must_be_instance_of Hotel::Reservation
      @result.room_number.must_equal first_available
    end

    it "selects the first available room for the given date range" do
      next_available = @available_rooms[1]

      next_available.must_equal 2

      result = @reservation_manager.reserve_available("2018-04-11", "2018-04-12")
      result.room_number.must_equal next_available

      next_available = @available_rooms[2]

      next_available.must_equal 3

      result = @reservation_manager.reserve_available("2018-04-11", "2018-04-12")
      result.room_number.must_equal next_available

      next_available = @available_rooms[3]

      next_available.must_equal 6

      result = @reservation_manager.reserve_available("2018-04-11", "2018-04-12")
      result.room_number.must_equal next_available
      skip
    end

    it "pushes the created reservation to the array corresponding to the first available room number in the rooms_and_reservations hash" do
      @available_rooms.first.must_equal 1

      rooms_and_reservations = @reservation_manager.rooms_and_reservations

      first_room_reservations = rooms_and_reservations[1]

      first_room_reservations.must_include @result
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
      @reservation_manager.reserve_available("2018-05-05", "2018-05-10")
      available = @reservation_manager.view_available("2018-05-05", "2018-05-10")
      first_five_available = available[0...5]
      first_five_available.must_equal [2, 3, 4, 5, 6]
      result = @reservation_manager.generate_block(5, "2018-05-05", "2018-05-10", 150.00)
      result.rooms.must_equal first_five_available
    end

    it "pushes the newly created block to the reservation manager's list of blocks" do
      reservation_manager = Hotel::ReservationManager.new
      reservation_manager.reserve_available("2018-05-05", "2018-05-10")
      reservation_manager.blocks.must_be_empty

      result = reservation_manager.generate_block(5, "2018-05-05", "2018-05-10", 150.00)

      reservation_manager.blocks.size.must_equal 1

      reservation_manager.blocks.each do |block|
        block.must_be_instance_of Hotel::Block
      end
    end

    it "raises an error if there aren't enough available rooms for the number requested" do
    end
  end

end # describe ReservationManager
