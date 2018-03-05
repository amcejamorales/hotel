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

end # describe ReservationManager
