require File.expand_path('../helper', __FILE__)

describe "TimeWithZone extensions" do
  describe "With Eastern Standard Time" do
    before do
      Time.zone = 'Eastern Time (US & Canada)'
    end

    it "know what a weekend day is" do
      assert( Time.zone.parse("April 9, 2010 10:30am").weekday?)
      assert(!Time.zone.parse("April 10, 2010 10:30am").weekday?)
      assert(!Time.zone.parse("April 11, 2010 10:30am").weekday?)
      assert( Time.zone.parse("April 12, 2010 10:30am").weekday?)
    end

    it "know a weekend day is not a workday" do
      assert( Time.zone.parse("April 9, 2010 10:45 am").workday?)
      assert(!Time.zone.parse("April 10, 2010 10:45 am").workday?)
      assert(!Time.zone.parse("April 11, 2010 10:45 am").workday?)
      assert( Time.zone.parse("April 12, 2010 10:45 am").workday?)
    end

    it "know a holiday is not a workday" do
      BusinessTime::Config.holidays << Date.parse("July 4, 2010")
      BusinessTime::Config.holidays << Date.parse("July 5, 2010")

      assert(!Time.zone.parse("July 4th, 2010 1:15 pm").workday?)
      assert(!Time.zone.parse("July 5th, 2010 2:37 pm").workday?)
    end

    it "know the beginning of the day for an instance" do
      first = Time.zone.parse("August 17th, 2010, 11:50 am")
      expecting = Time.zone.parse("August 17th, 2010, 9:00 am")
      assert_equal expecting, Time.beginning_of_workday(first)
    end

    it "know the end of the day for an instance" do
      first = Time.zone.parse("August 17th, 2010, 11:50 am")
      expecting = Time.zone.parse("August 17th, 2010, 5:00 pm")
      assert_equal expecting, Time.end_of_workday(first)
    end

    it "know a holiday passed as an option is not a workday" do
      july_4 = Date.parse("July 4, 2010")
      july_5 = Date.parse("July 5, 2010")

      assert(!Time.zone.parse("July 4th, 2010 1:15 pm").workday?(holidays: [july_4]))
      assert(!Time.zone.parse("July 5th, 2010 2:37 pm").workday?(holidays: [july_5]))
    end
  end

  describe "With UTC Timezone" do
    before do
      Time.zone = 'UTC'
    end

    it "know what a weekend day is" do
      assert( Time.zone.parse("April 9, 2010 10:30am").weekday?)
      assert(!Time.zone.parse("April 10, 2010 10:30am").weekday?)
      assert(!Time.zone.parse("April 11, 2010 10:30am").weekday?)
      assert( Time.zone.parse("April 12, 2010 10:30am").weekday?)
    end

    it "know a weekend day is not a workday" do
      assert( Time.zone.parse("April 9, 2010 10:45 am").workday?)
      assert(!Time.zone.parse("April 10, 2010 10:45 am").workday?)
      assert(!Time.zone.parse("April 11, 2010 10:45 am").workday?)
      assert( Time.zone.parse("April 12, 2010 10:45 am").workday?)
    end

    it "know a holiday is not a workday" do
      BusinessTime::Config.holidays << Date.parse("July 4, 2010")
      BusinessTime::Config.holidays << Date.parse("July 5, 2010")

      assert(!Time.zone.parse("July 4th, 2010 1:15 pm").workday?)
      assert(!Time.zone.parse("July 5th, 2010 2:37 pm").workday?)
    end

    it "know the beginning of the day for an instance" do
      first = Time.zone.parse("August 17th, 2010, 11:50 am")
      expecting = Time.zone.parse("August 17th, 2010, 9:00 am")
      assert_equal expecting, Time.beginning_of_workday(first)
    end

    it "know the end of the day for an instance" do
      first = Time.zone.parse("August 17th, 2010, 11:50 am")
      expecting = Time.zone.parse("August 17th, 2010, 5:00 pm")
      assert_equal expecting, Time.end_of_workday(first)
    end

    it "know a holiday passed as an option is not a workday" do
      july_4 = Date.parse("July 4, 2010")
      july_5 = Date.parse("July 5, 2010")

      assert(!Time.zone.parse("July 4th, 2010 1:15 pm").workday?(holidays: [july_4]))
      assert(!Time.zone.parse("July 5th, 2010 2:37 pm").workday?(holidays: [july_5]))
    end
  end
end
