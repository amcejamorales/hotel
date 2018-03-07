require_relative 'spec_helper'
require_relative '../lib/hotel'

describe Hotel do
  describe "#overlap?" do
    it "returns a Boolean" do
    end

    it "returns false if the first date range comes completely before the second" do
      first_date = ""
    end

    it "returns false if the first date range comes completely after the second" do
    end

    it "returns false if the end of the first date range falls on the same date as the beginning of the second date range" do
    end

    it "returns false if the beginning of the first date range falls on the same date as the end of the second date range" do
    end
  end # describe overlap?

  describe "#parse_date" do
    before do
      date = "2018-03-07"
      @parsed_date = Hotel::parse_date(date)
    end
    it "returns a Date object" do
      @parsed_date.must_be_instance_of Date
    end

    it "parses out a string into a Date object" do
      date = Date.new(2018, 03, 07)
      @parsed_date.must_equal date
    end
  end # describe parse_date
end # describe Hotel module
