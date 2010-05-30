require 'helper'

class TestBusinessHours < Test::Unit::TestCase

  context "with a standard Time object" do

    should "move to tomorrow if we add 8 business hours" do
      first = Time.parse("Aug 4 2010, 9:35 am")
      later = 8.business_hours.after(first)
      expected = Time.parse("Aug 5 2010, 9:35 am")
      assert_equal expected, later
    end

    should "move to yesterday if we subtract 8 business hours" do
      first = Time.parse("Aug 4 2010, 9:35 am")
      later = 8.business_hours.before(first)
      expected = Time.parse("Aug 3 2010, 9:35 am")
      assert_equal expected, later
    end

    should "take into account a weekend when adding an hour" do
      friday_afternoon = Time.parse("April 9th, 4:50 pm")
      monday_morning = 1.business_hour.after(friday_afternoon)
      expected = Time.parse("April 12th 2010, 9:50 am")
      assert_equal expected, monday_morning
    end

    should "take into account a weekend when subtracting an hour" do
      monday_morning = Time.parse("April 12th 2010, 9:50 am")
      friday_afternoon = 1.business_hour.before(monday_morning)
      expected = Time.parse("April 9th 2010, 4:50 pm")
      assert_equal expected, friday_afternoon
    end

    should "take into account a holiday" do
      BusinessTime::Config.holidays << Date.parse("July 5th, 2010")
      friday_afternoon = Time.parse("July 2nd 2010, 4:50pm")
      tuesday_morning = 1.business_hour.after(friday_afternoon)
      expected = Time.parse("July 6th 2010, 9:50 am")
      assert_equal expected, tuesday_morning
    end

    should "add hours in the middle of the workday"  do
      monday_morning = Time.parse("April 12th 2010, 9:50 am")
      later = 3.business_hours.after(monday_morning)
      expected = Time.parse("April 12th 2010, 12:50 pm")
      assert_equal expected, later
    end

    should "roll forward to 9 am if asked in the early morning" do
      crack_of_dawn_monday = Time.parse("Mon Apr 26, 04:30:00, 2010")
      monday_morning = Time.parse("Mon Apr 26, 09:00:00, 2010")
      assert_equal monday_morning, Time.roll_forward(crack_of_dawn_monday)
    end

    should "roll forward to the next morning if aftern business hours" do
      monday_evening = Time.parse("Mon Apr 26, 18:00:00, 2010")
      tuesday_morning = Time.parse("Tue Apr 27, 09:00:00, 2010")
      assert_equal tuesday_morning, Time.roll_forward(monday_evening)
    end

    should "consider any time on a weekend as equivalent to monday morning" do
      sunday = Time.parse("Sun Apr 25 12:06:56, 2010")
      monday = Time.parse("Mon Apr 26, 09:00:00, 2010")
      assert_equal 1.business_hour.before(monday), 1.business_hour.before(sunday)
    end
  end

end
