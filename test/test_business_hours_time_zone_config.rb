require File.expand_path('../helper', __FILE__)

describe "business hours" do
  describe "with BusinessTime::Config.time_zone set to Eastern and Time.zone set to UTC" do
    before do
      BusinessTime::Config.time_zone = 'Eastern Time (US & Canada)'
      Time.zone = 'UTC'
    end

    it "uses BusinessTime::Config.time_zone" do
      first = BusinessTime::Config.time_zone.parse("February 3rd, 2014, 3:30 pm")
      later = 1.business_hour.after(first)
      expected = BusinessTime::Config.time_zone.parse("February 3rd, 2014, 4:30 pm")
      assert_equal expected, later
    end

    it "converts Time.zone into BusinessTime::Config.time_zone" do
      # EST = UTC-5
      # UTC = EST+5
      first = Time.zone.parse("February 3rd, 2014, 8:30 pm")
      later = 1.business_hour.after(first)
      expected = Time.zone.parse("February 3rd, 2014, 9:30 pm")
      assert_equal expected, later
    end
  end
end
