require 'helper'

class TestTimeWithZoneExtensions < Test::Unit::TestCase
  
  context "With Eastern Standard Time" do
    setup do
      Time.zone = 'Eastern Time (US & Canada)'
    end
    
    should "know what a weekend day is" do
      assert( Time.weekday?(Time.zone.parse("April 9, 2010 10:30am")))
      assert(!Time.weekday?(Time.zone.parse("April 10, 2010 10:30am")))
      assert(!Time.weekday?(Time.zone.parse("April 11, 2010 10:30am")))
      assert( Time.weekday?(Time.zone.parse("April 12, 2010 10:30am")))
    end
  
    should "know a weekend day is not a workday" do
      assert( Time.workday?(Time.zone.parse("April 9, 2010 10:45 am")))
      assert(!Time.workday?(Time.zone.parse("April 10, 2010 10:45 am")))
      assert(!Time.workday?(Time.zone.parse("April 11, 2010 10:45 am")))
      assert( Time.workday?(Time.zone.parse("April 12, 2010 10:45 am")))
    end
  
    should "know a holiday is not a workday" do
      BusinessTime::Config.reset
    
      BusinessTime::Config.holidays << Date.parse("July 4, 2010")
      BusinessTime::Config.holidays << Date.parse("July 5, 2010")
    
      assert(!Time.workday?(Time.zone.parse("July 4th, 2010 1:15 pm")))
      assert(!Time.workday?(Time.zone.parse("July 5th, 2010 2:37 pm")))
    end
  
  
    should "know the beginning of the day for an instance" do
      first = Time.zone.parse("August 17th, 2010, 11:50 am")
      expecting = Time.zone.parse("August 17th, 2010, 9:00 am")
      assert_equal expecting, Time.beginning_of_workday(first)
    end
  
    should "know the end of the day for an instance" do
      first = Time.zone.parse("August 17th, 2010, 11:50 am")
      expecting = Time.zone.parse("August 17th, 2010, 5:00 pm")
      assert_equal expecting, Time.end_of_workday(first)
    end
  end
  
  
  context "With UTC Timezone" do
    setup do
      Time.zone = 'UTC'
    end
    
    should "know what a weekend day is" do
      assert( Time.weekday?(Time.zone.parse("April 9, 2010 10:30am")))
      assert(!Time.weekday?(Time.zone.parse("April 10, 2010 10:30am")))
      assert(!Time.weekday?(Time.zone.parse("April 11, 2010 10:30am")))
      assert( Time.weekday?(Time.zone.parse("April 12, 2010 10:30am")))
    end
  
    should "know a weekend day is not a workday" do
      assert( Time.workday?(Time.zone.parse("April 9, 2010 10:45 am")))
      assert(!Time.workday?(Time.zone.parse("April 10, 2010 10:45 am")))
      assert(!Time.workday?(Time.zone.parse("April 11, 2010 10:45 am")))
      assert( Time.workday?(Time.zone.parse("April 12, 2010 10:45 am")))
    end
  
    should "know a holiday is not a workday" do
      BusinessTime::Config.reset
    
      BusinessTime::Config.holidays << Date.parse("July 4, 2010")
      BusinessTime::Config.holidays << Date.parse("July 5, 2010")
    
      assert(!Time.workday?(Time.zone.parse("July 4th, 2010 1:15 pm")))
      assert(!Time.workday?(Time.zone.parse("July 5th, 2010 2:37 pm")))
    end
  
  
    should "know the beginning of the day for an instance" do
      first = Time.zone.parse("August 17th, 2010, 11:50 am")
      expecting = Time.zone.parse("August 17th, 2010, 9:00 am")
      assert_equal expecting, Time.beginning_of_workday(first)
    end
  
    should "know the end of the day for an instance" do
      first = Time.zone.parse("August 17th, 2010, 11:50 am")
      expecting = Time.zone.parse("August 17th, 2010, 5:00 pm")
      assert_equal expecting, Time.end_of_workday(first)
    end
  end
  
end
