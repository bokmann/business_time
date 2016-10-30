require File.expand_path('../helper', __FILE__)

module BusinessTime
  describe ParsedTime do
    describe "new" do
      it "sets hour, min, sec" do
        parsed_time = ParsedTime.new(9, 10, 11)
        assert_equal parsed_time.hour, 9
        assert_equal parsed_time.min, 10
        assert_equal parsed_time.sec, 11
      end

      it "defaults sec to 0" do
        parsed_time = ParsedTime.new(9, 10)
        assert_equal parsed_time.hour, 9
        assert_equal parsed_time.min, 10
        assert_equal parsed_time.sec, 0
      end

      it "defaults min, sec to 0" do
        parsed_time = ParsedTime.new(9)
        assert_equal parsed_time.hour, 9
        assert_equal parsed_time.min, 0
        assert_equal parsed_time.sec, 0
      end
    end

    describe "parse" do
      it "parses time" do
        parsed_time = ParsedTime.parse("09:10:11")
        assert_equal parsed_time.hour, 9
        assert_equal parsed_time.min, 10
        assert_equal parsed_time.sec, 11
      end

      it "parses PM time" do
        parsed_time = ParsedTime.parse("09:00pm")
        assert_equal parsed_time.hour, 21
      end

      it "accepts a time" do
        time = Time.parse("9:10:11")
        parsed_time = ParsedTime.parse(time)
        assert_equal parsed_time.hour, 9
        assert_equal parsed_time.min, 10
        assert_equal parsed_time.sec, 11
      end
    end

    describe "to_s" do
      it "returns hh:mm:ss" do
        assert_equal ParsedTime.new(9, 10, 11).to_s, "9:10:11"
      end
    end

    describe "-" do
      it "returns the time difference in seconds" do
        parsed_time1 = ParsedTime.new(9, 10, 11)
        parsed_time2 = ParsedTime.new(8, 9, 10)

        assert_equal parsed_time1 - parsed_time2, 3661
      end
    end

    describe "<=>" do
      it 'returns greater' do
        parsed_time1 = ParsedTime.new(9, 10, 11)
        parsed_time2 = ParsedTime.new(9, 10, 10)

        assert_equal parsed_time1 > parsed_time2, true
      end

      it 'returns smaller' do
        parsed_time1 = ParsedTime.new(9, 10, 10)
        parsed_time2 = ParsedTime.new(9, 10, 11)

        assert_equal parsed_time1 < parsed_time2, true
      end

      it 'returns equal' do
        parsed_time1 = ParsedTime.new(9, 10, 10)
        parsed_time2 = ParsedTime.new(9, 10, 10)

        assert_equal parsed_time1 == parsed_time2, true
      end
    end
  end
end

