require_relative 'spec_helper'

describe Hotel::Block do

  before do
    @reservation_manager = Hotel::ReservationManager.new
  end

  describe "#initialize" do
    it "can be created" do
      block = Hotel::Block.new(5, "2018-05-05", "2018-05-10", 150.00)
      block.must_be_instance_of Hotel::Block
    end

    it "raises an error if you try to put more than 5 rooms in a block" do
      block = proc { Hotel::Block.new(6, "2018-05-05", "2018-05-10", 150.00) }
      block.must_raise ArgumentError
    end
  end # initialize

end # describe Helper::Block
