require File.expand_path('../helper', __FILE__)

describe "business days" do
  describe "with a standard Date object" do
    it "move to tomorrow if we add a business day" do
      first = Date.parse("April 13th, 2010")
      later = 1.business_day.after(first)
      expected = Date.parse("April 14th, 2010")
      assert_equal expected, later
    end

    it "move to yesterday is we subtract a business day" do
      first = Date.parse("April 13th, 2010")
      before = 1.business_day.before(first)
      expected = Date.parse("April 12th, 2010")
      assert_equal expected, before
    end

    it "take into account the weekend when adding a day" do
      first = Date.parse("April 9th, 2010")
      after = 1.business_day.after(first)
      expected = Date.parse("April 12th, 2010")
      assert_equal expected, after
    end

    it "take into account the weekend when subtracting a day" do
      first = Date.parse("April 12th, 2010")
      before = 1.business_day.before(first)
      expected = Date.parse("April 9th, 2010")
      assert_equal expected, before
    end

    it "move forward one week when adding 5 business days" do
      first = Date.parse("April 9th, 2010")
      after = 5.business_days.after(first)
      expected = Date.parse("April 16th, 2010")
      assert_equal expected, after
    end

    it "move backward one week when subtracting 5 business days" do
      first = Date.parse("April 16th, 2010")
      before = 5.business_days.before(first)
      expected = Date.parse("April 9th, 2010")
      assert_equal expected, before
    end

    it "take into account a holiday when adding a day" do
      three_day_weekend = Date.parse("July 5th, 2010")
      BusinessTime::Config.holidays << three_day_weekend
      friday_afternoon = Date.parse("July 2nd, 2010")
      tuesday_afternoon = 1.business_day.after(friday_afternoon)
      expected = Date.parse("July 6th, 2010")
      assert_equal expected, tuesday_afternoon
    end

    it "take into account a holiday on a weekend" do
      july_4 = Date.parse("July 4th, 2010")
      BusinessTime::Config.holidays << july_4
      friday_afternoon = Date.parse("July 2nd, 2010")
      monday_afternoon = 1.business_day.after(friday_afternoon)
      expected = Date.parse("July 5th, 2010")
      assert_equal expected, monday_afternoon
    end

    it "move to monday if we add one business day during a weekend" do
      saturday = Date.parse("April 10th, 2010")
      later = 1.business_days.after(saturday)
      expected = Date.parse("April 12th, 2010")
      assert_equal expected, later
    end

    it "move to friday if we subtract one business day during a weekend" do
      saturday = Date.parse("April 10th, 2010")
      before = 1.business_days.before(saturday)
      expected = Date.parse("April 9th, 2010")
      assert_equal expected, before
    end
  end
end
