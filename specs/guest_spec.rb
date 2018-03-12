require_relative 'spec_helper'

describe Hotel::Guest do
  describe "#initialize" do
    before do
      @guest = Hotel::Guest.new(1, "Sam Jackson", "(610) 555-555", "1111-2222-3333-4444")
    end
    it "can be created" do
      @guest.must_be_instance_of Hotel::Guest
      @guest.must_respond_to :id
      @guest.must_respond_to :name
      @guest.must_respond_to :phone
      @guest.must_respond_to :credit_card_number
    end

  end # describe #initialize
end # describe Guest
