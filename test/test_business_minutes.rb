require 'helper'

class TestBusinessMinutes < Test::Unit::TestCase

  context "with a standard Time object" do

    should "move 30 minutes ahead" do
      first = Time.parse("April 13th, 2010, 11:00 am")
      later = 30.business_minutes.after(first)
      expected = Time.parse("April 13th, 2010, 11:30 am")
      assert_equal expected, later
    end

    should "move to tomorrow if we add 440 business minutes" do
      first = Time.parse("April 13th, 2010, 11:00 am")
      later = 440.business_minutes.after(first)
      expected = Time.parse("April 14th, 2010, 10:20 am")
      assert_equal expected, later
    end

    should "move to yesterday is we subtract 360 business minutes" do
      first = Time.parse("April 13th, 2010, 11:00 am")
      before = 360.business_minutes.before(first)
      expected = Time.parse("April 12th, 2010, 01:00 pm")
      assert_equal expected, before
    end

    should "take into account the weekend when adding 440 minutes" do
      first = Time.parse("April 9th, 2010, 12:33 pm")
      after = 440.business_minutes.after(first)
      expected = Time.parse("April 12th, 2010, 11:53 am")
      assert_equal expected, after
    end

    should "take into account the weekend when subtracting 360 minutes" do
      first = Time.parse("April 12th, 2010, 12:33 pm")
      before = 360.business_minutes.before(first)
      expected = Time.parse("April 9th, 2010, 02:33 pm")
      assert_equal expected, before
    end

    should "move forward one week when adding 2400 business minutes" do
      first = Time.parse("April 9th, 2010, 12:33 pm")
      after = 2400.business_minutes.after(first)
      expected = Time.parse("April 16th, 2010, 12:33 pm")
      assert_equal expected, after
    end

    should "move backward one week when subtracting 2400 business mintes" do
      first = Time.parse("April 16th, 2010, 12:33 pm")
      before = 2400.business_minutes.before(first)
      expected = Time.parse("April 9th, 2010, 12:33 pm")
      assert_equal expected, before
    end

    should "take into account a holiday when adding 480 minutes" do
      three_day_weekend = Date.parse("July 5th, 2010")
      BusinessTime::Config.holidays << three_day_weekend
      friday_afternoon = Time.parse("July 2nd, 2010, 4:50 pm")
      tuesday_afternoon = 480.business_minutes.after(friday_afternoon)
      expected = Time.parse("July 6th, 2010, 4:50 pm")
      assert_equal expected, tuesday_afternoon
    end

    should "take into account a holiday on a weekend" do
      BusinessTime::Config.reset
      july_4 = Date.parse("July 4th, 2010")
      BusinessTime::Config.holidays << july_4
      friday_afternoon = Time.parse("July 2nd, 2010, 4:50 pm")
      monday_afternoon = 480.business_minutes.after(friday_afternoon)
      expected = Time.parse("July 5th, 2010, 4:50 pm")
      assert_equal expected, monday_afternoon
    end
  end

end
