require File.expand_path('../helper', __FILE__)

describe "business days" do
  describe "with a TimeWithZone object set to the Eastern timezone" do
    before { Time.zone = 'Eastern Time (US & Canada)' }

    describe "when adding/subtracting positive number of business days" do
      it "move to tomorrow if we add a business day" do
        first = Time.zone.parse("April 13th, 2010, 11:00 am")
        later = 1.business_day.after(first)
        expected = Time.zone.parse("April 14th, 2010, 11:00 am")
        assert_equal expected, later
      end

      it "move to yesterday is we subtract a business day" do
        first = Time.zone.parse("April 13th, 2010, 11:00 am")
        before = 1.business_day.before(first)
        expected = Time.zone.parse("April 12th, 2010, 11:00 am")
        assert_equal expected, before
      end

      it "take into account the weekend when adding a day" do
        first = Time.zone.parse("April 9th, 2010, 12:33 pm")
        after = 1.business_day.after(first)
        expected = Time.zone.parse("April 12th, 2010, 12:33 pm")
        assert_equal expected, after
      end

      it "take into account the weekend when subtracting a day" do
        first = Time.zone.parse("April 12th, 2010, 12:33 pm")
        before = 1.business_day.before(first)
        expected = Time.zone.parse("April 9th, 2010, 12:33 pm")
        assert_equal expected, before
      end

      it "move forward one week when adding 5 business days" do
        first = Time.zone.parse("April 9th, 2010, 12:33 pm")
        after = 5.business_days.after(first)
        expected = Time.zone.parse("April 16th, 2010, 12:33 pm")
        assert_equal expected, after
      end

      it "move backward one week when subtracting 5 business days" do
        first = Time.zone.parse("April 16th, 2010, 12:33 pm")
        before = 5.business_days.before(first)
        expected = Time.zone.parse("April 9th, 2010, 12:33 pm")
        assert_equal expected, before
      end

      it "take into account a holiday when adding a day" do
        three_day_weekend = Date.parse("July 5th, 2010")
        BusinessTime::Config.holidays << three_day_weekend
        friday_afternoon = Time.zone.parse("July 2nd, 2010, 4:50 pm")
        tuesday_afternoon = 1.business_day.after(friday_afternoon)
        expected = Time.zone.parse("July 6th, 2010, 4:50 pm")
        assert_equal expected, tuesday_afternoon
      end

      it "take into account a holiday on a weekend" do
        july_4 = Date.parse("July 4th, 2010")
        BusinessTime::Config.holidays << july_4
        friday_afternoon = Time.zone.parse("July 2nd, 2010, 4:50 pm")
        monday_afternoon = 1.business_day.after(friday_afternoon)
        expected = Time.zone.parse("July 5th, 2010, 4:50 pm")
        assert_equal expected, monday_afternoon
      end

      it "take into account a holiday passed as an option when adding a day" do
        three_day_weekend = Date.parse("July 5th, 2010")
        friday_afternoon = Time.zone.parse("July 2nd, 2010, 4:50 pm")
        tuesday_afternoon = 1.business_day.after(friday_afternoon, holidays: [three_day_weekend])
        expected = Time.zone.parse("July 6th, 2010, 4:50 pm")
        assert_equal expected, tuesday_afternoon
      end

      it "take into account a holiday passed as an option on a weekend" do
        july_4 = Date.parse("July 4th, 2010")
        friday_afternoon = Time.zone.parse("July 2nd, 2010, 4:50 pm")
        monday_afternoon = 1.business_day.after(friday_afternoon, holidays: [july_4])
        expected = Time.zone.parse("July 5th, 2010, 4:50 pm")
        assert_equal expected, monday_afternoon
      end
    end

    describe "when adding/subtracting negative number of business days" do
      it "move to yesterday if we add a negative business day" do
        first = Time.zone.parse("April 14th, 2010, 11:00 am")
        before = -1.business_day.after(first)
        expected = Time.zone.parse("April 13th, 2010, 11:00 am")
        assert_equal expected, before
      end

      it "move to tomorrow is we subtract a negative business day" do
        first = Time.zone.parse("April 12th, 2010, 11:00 am")
        after = -1.business_day.before(first)
        expected = Time.zone.parse("April 13th, 2010, 11:00 am")
        assert_equal expected, after
      end

      it "take into account the weekend when adding a negative day" do
        first = Time.zone.parse("April 12th, 2010, 12:33 pm")
        before = -1.business_day.after(first)
        expected = Time.zone.parse("April 9th, 2010, 12:33 pm")
        assert_equal expected, before
      end

      it "take into account the weekend when subtracting a negative day" do
        first = Time.zone.parse("April 9th, 2010, 12:33 pm")
        after = -1.business_day.before(first)
        expected = Time.zone.parse("April 12th, 2010, 12:33 pm")
        assert_equal expected, after
      end

      it "move backward one week when adding -5 business days" do
        first = Time.zone.parse("April 16th, 2010, 12:33 pm")
        before = -5.business_days.after(first)
        expected = Time.zone.parse("April 9th, 2010, 12:33 pm")
        assert_equal expected, before
      end

      it "move forward one week when subtracting -5 business days" do
        first = Time.zone.parse("April 9th, 2010, 12:33 pm")
        after = -5.business_days.before(first)
        expected = Time.zone.parse("April 16th, 2010, 12:33 pm")
        assert_equal expected, after
      end

      it "take into account a holiday when adding a negative day" do
        three_day_weekend = Date.parse("July 5th, 2010")
        BusinessTime::Config.holidays << three_day_weekend
        tuesday_afternoon = Time.zone.parse("July 6th, 2010, 4:50 pm")
        friday_afternoon = -1.business_day.after(tuesday_afternoon)
        expected = Time.zone.parse("July 2nd, 2010, 4:50 pm")
        assert_equal expected, friday_afternoon
      end

      it "take into account a holiday on a weekend" do
        july_4 = Date.parse("July 4th, 2010")
        BusinessTime::Config.holidays << july_4
        monday_afternoon = Time.zone.parse("July 5th, 2010, 4:50 pm")
        friday_afternoon = -1.business_day.after(monday_afternoon)
        expected = Time.zone.parse("July 2nd, 2010, 4:50 pm")
        assert_equal expected, friday_afternoon
      end

      it "take into account a holiday passed as an option when adding a negative day" do
        three_day_weekend = Date.parse("July 5th, 2010")
        tuesday_afternoon = Time.zone.parse("July 6th, 2010, 4:50 pm")
        friday_afternoon = -1.business_day.after(tuesday_afternoon, holidays: [three_day_weekend])
        expected = Time.zone.parse("July 2nd, 2010, 4:50 pm")
        assert_equal expected, friday_afternoon
      end

      it "take into account a holiday passed as an option on a weekend" do
        july_4 = Date.parse("July 4th, 2010")
        monday_afternoon = Time.zone.parse("July 5th, 2010, 4:50 pm")
        friday_afternoon = -1.business_day.after(monday_afternoon, holidays: [july_4])
        expected = Time.zone.parse("July 2nd, 2010, 4:50 pm")
        assert_equal expected, friday_afternoon
      end
    end
  end
end
