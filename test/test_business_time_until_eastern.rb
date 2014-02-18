require File.expand_path('../helper', __FILE__)

describe "#business_time_until" do
  describe "with a TimeWithZone object in US Eastern" do
    before do
      Time.zone = 'Eastern Time (US & Canada)'
    end

    it "should work..." do
      three_o_clock = Time.zone.parse("2014-02-17 15:00:00")
      four_o_clock = Time.zone.parse("2014-02-17 16:00:00")
      assert_equal 60*60, three_o_clock.business_time_until(four_o_clock)
    end
  end
end
