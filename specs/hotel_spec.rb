require_relative 'spec_helper'
require_relative '../lib/hotel'

describe Hotel do
  describe "#overlap?" do
    before do
      @first_start_date = "2018-01-05"
      @first_end_date = "2018-01-10"
    end

    it "returns a Boolean" do
      second_start_date = "2018-02-05"
      second_end_date = "2018-02-10"
      result = Hotel::overlap?(@first_start_date, @first_end_date, second_start_date, second_end_date)

      result.must_be_instance_of FalseClass

      second_start_date = "2018-01-05"
      second_end_date = "2018-01-10"

      result = Hotel::overlap?(@first_start_date, @first_end_date, second_start_date, second_end_date)

      result.must_be_instance_of TrueClass

    end

    describe "no overlap" do

      it "returns false if the first date range comes completely before the second" do
        second_start_date = "2018-02-05"
        second_end_date = "2018-02-10"
        result = Hotel::overlap?(@first_start_date, @first_end_date, second_start_date, second_end_date)
        result.must_equal false
      end

      it "returns false if the first date range comes completely after the second" do
        second_start_date = "2017-12-05"
        second_end_date = "2017-12-10"
        result = Hotel::overlap?(@first_start_date, @first_end_date, second_start_date, second_end_date)
        result.must_equal false
      end

      it "returns false if the end of the first date range falls on the same date as the beginning of the second date range" do
        second_start_date = "2018-01-10"
        second_end_date = "2018-01-15"
        result = Hotel::overlap?(@first_start_date, @first_end_date, second_start_date, second_end_date)
        result.must_equal false
      end

      it "returns false if the beginning of the first date range falls on the same date as the end of the second date range" do
        second_start_date = "2017-12-31"
        second_end_date = "2018-01-05"
        result = Hotel::overlap?(@first_start_date, @first_end_date, second_start_date, second_end_date)
        result.must_equal false
      end
    end # describe no overlap

    describe "actual overlap" do

      it "returns true if the first start date is the same as the second start date and the first end date is the same as the second end date" do
        second_start_date = "2018-01-05"
        second_end_date = "2018-01-10"
        result = Hotel::overlap?(@first_start_date, @first_end_date, second_start_date, second_end_date)
        result.must_equal true
      end

      it "returns true if the first date range completely contains the second" do
        second_start_date = "2018-01-06"
        second_end_date = "2018-01-09"
        result = Hotel::overlap?(@first_start_date, @first_end_date, second_start_date, second_end_date)
        result.must_equal true
      end

      it "returns true if the first date range is completely contained within the second" do
        second_start_date = "2018-01-04"
        second_end_date = "2018-01-11"
        result = Hotel::overlap?(@first_start_date, @first_end_date, second_start_date, second_end_date)
        result.must_equal true
      end

      it "returns true if the first date range overlaps with the back of the second" do
        second_start_date = "2018-01-06"
        second_end_date = "2018-01-11"
        result = Hotel::overlap?(@first_start_date, @first_end_date, second_start_date, second_end_date)
        result.must_equal true
      end

      it "returns true if the front of the first date range overlaps with the second" do
        second_start_date = "2018-01-04"
        second_end_date = "2018-01-09"
        result = Hotel::overlap?(@first_start_date, @first_end_date, second_start_date, second_end_date)
        result.must_equal true
      end

      it "returns true if the first start date comes before the second start date and both date ranges end on the same date" do
        second_start_date = "2018-01-06"
        second_end_date = "2018-01-10"
        result = Hotel::overlap?(@first_start_date, @first_end_date, second_start_date, second_end_date)
        result.must_equal true
      end

      it "returns true if the first start date comes after the second start date and both date ranges end on the same date" do
        second_start_date = "2018-01-04"
        second_end_date = "2018-01-10"
        result = Hotel::overlap?(@first_start_date, @first_end_date, second_start_date, second_end_date)
        result.must_equal true
      end

      it "returns true if both date ranges start on the same date and the first end date comes after the second end date" do
        second_start_date = "2018-01-05"
        second_end_date = "2018-01-09"
        result = Hotel::overlap?(@first_start_date, @first_end_date, second_start_date, second_end_date)
        result.must_equal true
      end

      it "returns true if both date ranges start on the same date and the first end date comes before the second end date" do
        second_start_date = "2018-01-05"
        second_end_date = "2018-01-11"
        result = Hotel::overlap?(@first_start_date, @first_end_date, second_start_date, second_end_date)
        result.must_equal true
      end

    end # describes actual overlap

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

  describe "#valid_date_range" do
    it "returns true if the date range is valid" do
      start_date = "2018-01-05"
      end_date = "2018-01-10"
      result = Hotel::valid_date_range(start_date, end_date)
      result.must_equal true

      start_date = "2018-01-10"
      end_date = "2018-01-10"
      result = Hotel::valid_date_range(start_date, end_date)
      result.must_equal true
    end

    it "raises an error if the end_date comes before the start_date" do
      start_date = "2018-01-10"
      end_date = "2018-01-05"
      result = proc { Hotel::valid_date_range(start_date, end_date) }
      result.must_raise ArgumentError
    end
  end # describe valid_date_range
end # describe Hotel module
