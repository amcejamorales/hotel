require_relative 'spec_helper'

describe Hotel::Reservation do

  before do
    COST_PER_NIGHT = 200.00
    @reservation_one = Hotel::Reservation.new(1, "2018-04-05", "2018-04-10")
  end

  describe "#initialize" do
    it "can be created" do
      @reservation_one.must_be_instance_of Hotel::Reservation
    end

    it "selects a valid room number" do
      @reservation_one.must_respond_to :room_number

      (1..20).must_include @reservation_one.room_number
    end

    it "returns an error for an invalid date range" do
      reservation_two = proc {  Hotel::Reservation.new(1, "2018-04-10", "2018-04-05") }

      reservation_two.must_raise
    end

  end # describe initialize

  describe "#reservation_length" do
    before do
      @reservation_length = @reservation_one.reservation_length
    end

    it "returns an integer" do
      @reservation_length.must_be_instance_of Integer
    end

    it "returns the length of a reservation in days" do
      num_nights = (Date.parse("2018-04-10") - Date.parse("2018-04-05")).to_i
      @reservation_length.must_equal num_nights
    end

    it "returns 1 for a two-day, one-night reservation" do
      reservation_three = Hotel::Reservation.new(1, "2018-04-05", "2018-04-06")
      num_nights = (Date.parse("2018-04-06") - Date.parse("2018-04-05")).to_i
      num_nights.must_equal 1

      result = reservation_three.reservation_length

      result.must_equal num_nights
    end

    it "returns 0 for a one-day, zero-night reservation" do
      skip
    end

  end # describe reservation_length

  describe "#total_cost" do
    before do
      @total_cost = @reservation_one.total_cost
    end

    it "returns a float" do
      @total_cost.must_be_instance_of Float
    end

    it "returns the total cost of a reservation" do
      num_nights = (Date.parse("2018-04-10") - Date.parse("2018-04-05")).to_i
      estimated_cost = num_nights * COST_PER_NIGHT

      estimated_cost.must_equal 1_000.00
      @total_cost.must_equal estimated_cost
    end
  end # describe #total_cost

  describe "#check_room_num" do
    it "verifies the room number entered is valid" do
      proc { Hotel::Reservation.new(21, "2018-04-05", "2018-04-10") }.must_raise

      proc { Hotel::Reservation.new(0, "2018-04-05", "2018-04-10") }.must_raise

      proc { Hotel::Reservation.new("two", "2018-04-05", "2018-04-10") }.must_raise

      proc { Hotel::Reservation.new([], "2018-04-05", "2018-04-10") }.must_raise

      proc { Hotel::Reservation.new({}, "2018-04-05", "2018-04-10") }.must_raise
    end
  end # describe check_room_num

end # describe Reservation
