require_relative 'spec_helper'

describe Hotel::Reservation do

  before do
    @reservation_one = Hotel::Reservation.new('2018-04-05', '2018-04-10')
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
    end

  end # describe initialize

  describe "#total_cost" do
  end # describe #total_cost

end # describe Reservation
