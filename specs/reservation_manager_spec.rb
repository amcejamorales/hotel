require_relative 'spec_helper'

describe Hotel::ReservationManager do
  before do
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

end # describe ReservationManager
