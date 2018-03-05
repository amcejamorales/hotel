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

  describe "#rooms_and_reservations" do
    before do
      @rooms_and_reservations = @reservation_manager.rooms_and_reservations
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
      @rooms_and_reservations.each do |room, reservation|
        reservation.must_equal []
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
      @room = @reservation_manager.reserve_room(1, "2018-04-05", "2018-04-10")
    end

    it "verifies the room number entered is valid" do
      room = proc { @reservation_manager.reserve_room(21, "2018-04-05", "2018-04-10") }
      room.must_raise

      room = proc { @reservation_manager.reserve_room(0, "2018-04-05", "2018-04-10") }
      room.must_raise

      room = proc { @reservation_manager.reserve_room("two", "2018-04-05", "2018-04-10") }
      room.must_raise

      room = proc { @reservation_manager.reserve_room([], "2018-04-05", "2018-04-10") }
      room.must_raise

      room = proc { @reservation_manager.reserve_room({}, "2018-04-05", "2018-04-10") }
      room.must_raise

    end

    it "returns the instance of Reservation" do
    end

    it "pushes the created reservation to the array corresponding to the room number in the rooms_and_reservations hash" do
    end

  end # reserve_room

end # describe ReservationManager
