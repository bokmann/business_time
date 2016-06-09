require File.expand_path('../helper', __FILE__)

describe "#business_time_until" do
  describe "on a TimeWithZone object in US Eastern" do
    before do
      ENV['TZ'] = 'Pacific Time (US & Canada)'
      Time.zone = 'Eastern Time (US & Canada)'
    end

    it "should respect the time zone" do
       three_o_clock = Time.zone.parse("2014-02-17 15:00:00")
       four_o_clock = Time.zone.parse("2014-02-17 16:00:00")
       assert_equal 60*60, three_o_clock.business_time_until(four_o_clock)
    end
    
    it "should respect the time zone for TimeWithZone" do
      three_o_clock = Time.zone.parse("2014-02-17 15:00:00")
      nine_o_clock = Time.zone.parse("2014-02-17 09:00:00")
      assert_equal nine_o_clock, Time.beginning_of_workday(three_o_clock)
    end

    it "should respect the time zone for Time" do
      three_o_clock = Time.parse("2014-02-17 15:00:00")
      nine_o_clock = Time.parse("2014-02-17 09:00:00")
      assert_equal nine_o_clock, Time.beginning_of_workday(three_o_clock)
    end
  end
end
