require File.expand_path('../helper', __FILE__)

describe "business days" do
  describe "with a standard Time object" do
    describe "when adding/subtracting positive business days" do
      it "should move to tomorrow if we add a business day" do
        first = Time.parse("April 13th, 2010, 11:00 am")
        later = 1.business_day.after(first)
        expected = Time.parse("April 14th, 2010, 11:00 am")
        assert_equal expected, later
      end

      it "should take into account the weekend when adding a day" do
        first = Time.parse("April 9th, 2010, 12:33 pm")
        after = 1.business_day.after(first)
        expected = Time.parse("April 12th, 2010, 12:33 pm")
        assert_equal expected, after
      end

      it "should pick next working day when adding zero days on the weekend" do
        first = Time.parse("April 10th, 2010, 12:33 pm")
        after = 0.business_days.after(first)
        expected = Time.parse("April 12th, 2010, 09:00 am")
        assert_equal expected, after
      end

      it "should pick previous working day when subtracting zero days on the weekend" do
        first = Time.parse("January 30th, 2016, 12:33 pm")
        after = 0.business_days.before(first)
        expected = Time.parse("January 29th, 2016, 09:00 am")
        assert_equal expected, after
      end

      it "should move forward one week when adding 5 business days" do
        first = Time.parse("April 9th, 2010, 12:33 pm")
        after = 5.business_days.after(first)
        expected = Time.parse("April 16th, 2010, 12:33 pm")
        assert_equal expected, after
      end

      it "should take into account a holiday when adding a day" do
        three_day_weekend = Date.parse("July 5th, 2010")
        BusinessTime::Config.holidays << three_day_weekend
        friday_afternoon = Time.parse("July 2nd, 2010, 4:50 pm")
        tuesday_afternoon = 1.business_day.after(friday_afternoon)
        expected = Time.parse("July 6th, 2010, 4:50 pm")
        assert_equal expected, tuesday_afternoon
      end

      it "should take into account a holiday on a weekend" do
        july_4 = Date.parse("July 4th, 2010")
        BusinessTime::Config.holidays << july_4
        friday_afternoon = Time.parse("July 2nd, 2010, 4:50 pm")
        monday_afternoon = 1.business_day.after(friday_afternoon)
        expected = Time.parse("July 5th, 2010, 4:50 pm")
        assert_equal expected, monday_afternoon
      end

      it "should move to tuesday if we add one business day during a weekend" do
        saturday = Time.parse("April 10th, 2010, 11:00 am")
        later = 1.business_days.after(saturday)
        expected = Time.parse("April 13th, 2010, 9:00 am")
        assert_equal expected, later
      end

      it "should move to tuesday if we add one business day during a weekend outside normal business hours" do
        saturday = Time.parse("April 10th, 2010, 11:55 pm")
        later = 1.business_days.after(saturday)
        expected = Time.parse("April 13th, 2010, 9:00 am")
        assert_equal expected, later
      end

      it "should return a business hour when adding one business day from before business hours" do
        wednesday = Time.parse("Wednesday October 14th, 2015, 01:54 am")
        later = 1.business_days.after(wednesday)
        expected = Time.parse("Thursday October 15th, 2015, 09:00 am")
        assert_equal expected, later
      end

      it "should move to thursday if we subtract one business day during a weekend" do
        saturday = Time.parse("April 10th, 2010, 11:00 am")
        before = 1.business_days.before(saturday)
        expected = Time.parse("April 8th, 2010, 9:00 am")
        assert_equal expected, before
      end

      it "should move to thursday if we subtract one business day during a weekend outside normal business hours" do
        saturday = Time.parse("April 10th, 2010, 03:00 am")
        before = 1.business_days.before(saturday)
        expected = Time.parse("April 8th, 2010, 9:00 am")
        assert_equal expected, before
      end

      it "should return a business hour when adding one business day from after business hours" do
        wednesday = Time.parse("Wednesday October 14th, 2015, 21:54 pm")
        later = 1.business_days.after(wednesday)
        expected = Time.parse("Friday October 16th, 2015, 09:00 am")
        assert_equal expected, later
      end

      it "should return a business hour when subtracting one business day from before business hours" do
        wednesday = Time.parse("Wednesday October 14th, 2015, 01:54 am")
        before = 1.business_days.before(wednesday)
        expected = Time.parse("Monday October 12th, 2015, 09:00 am")
        assert before.during_business_hours?
        assert_equal expected, before
      end

      it "should return a business hour when subtracting one business day from after business hours" do
        wednesday = Time.parse("Wednesday October 14th, 2015, 21:54 pm")
        before = 1.business_days.before(wednesday)
        expected = Time.parse("Tuesday October 13th, 2015, 09:00 am")
        assert before.during_business_hours?
        assert_equal expected, before
      end

      it "should move to yesterday is we subtract a business day" do
        first = Time.parse("April 13th, 2010, 11:00 am")
        before = 1.business_day.before(first)
        expected = Time.parse("April 12th, 2010, 11:00 am")
        assert_equal expected, before
      end

      it "should take into account the weekend when subtracting a day" do
        first = Time.parse("April 12th, 2010, 12:33 pm")
        before = 1.business_day.before(first)
        expected = Time.parse("April 9th, 2010, 12:33 pm")
        assert_equal expected, before
      end

      it "should move backward one week when subtracting 5 business days" do
        first = Time.parse("April 16th, 2010, 12:33 pm")
        before = 5.business_days.before(first)
        expected = Time.parse("April 9th, 2010, 12:33 pm")
        assert_equal expected, before
      end

      it "gets the next business day if it is a work day" do
        work_day = Time.parse("February 25th, 2019, 12:30 pm")
        after = Time.next_business_day(work_day)
        expected = Time.parse("February 26th, 2019, 12:30 pm")
        assert_equal expected, after
      end

      it "gets the next business day if it is a weekend" do
        weekend_day = Time.parse("February 23th, 2019, 12:30 pm")
        after = Time.next_business_day(weekend_day)
        expected = Time.parse("February 25th, 2019, 12:30 pm")
        assert_equal expected, after
      end
    end

    describe "when adding/subtracting negative business days" do
      it "should move to yesterday if we add a negative business day" do
        first = Time.parse("April 13th, 2010, 11:00 am")
        before = -1.business_day.after(first)
        expected = Time.parse("April 12th, 2010, 11:00 am")
        assert_equal expected, before
      end

      it "should take into account the weekend when adding a negative day" do
        first = Time.parse("April 12th, 2010, 12:33 pm")
        before = -1.business_day.after(first)
        expected = Time.parse("April 9th, 2010, 12:33 pm")
        assert_equal expected, before
      end

      it "should move bacward one week when adding 5 negative business days" do
        first = Time.parse("April 16th, 2010, 12:33 pm")
        before = -5.business_days.after(first)
        expected = Time.parse("April 9th, 2010, 12:33 pm")
        assert_equal expected, before
      end

      it "should take into account a holiday on a weekend when adding a negative day" do
        july_4 = Date.parse("July 4th, 2010")
        BusinessTime::Config.holidays << july_4
        monday_afternoon = Time.parse("July 5th, 2010, 4:50 pm")
        friday_afternoon = -1.business_day.after(monday_afternoon)
        expected = Time.parse("July 2nd, 2010, 4:50 pm")
        assert_equal expected, friday_afternoon
      end

      it "should move to thursday if we add one negative business day during weekend" do
        saturday = Time.parse("April 10th, 2010, 11:00 am")
        before = -1.business_days.after(saturday)
        expected = Time.parse("April 8th, 2010, 09:00 am")
        assert_equal expected, before
      end

      it "should return a business hour when adding one negative business day from before business hours" do
        wednesday = Time.parse("Wednesday October 14th, 2015, 01:54 am")
        before  = -1.business_days.after(wednesday)
        expected = Time.parse("Monday October 12th, 2015, 09:00 am")
        assert_equal expected, before
      end

      it "should return a business hour when adding one negative business day from after business hours" do
        wednesday = Time.parse("Wednesday October 14th, 2015, 21:54 pm")
        before = -1.business_days.after(wednesday)
        expected = Time.parse("Tuesday October 13th, 2015, 09:00 am")
        assert_equal expected, before
      end

      it "should move to tomorrow if we subtract a negative business day" do
        first = Time.parse("April 13th, 2010, 11:00 am")
        later = -1.business_day.before(first)
        expected = Time.parse("April 14th, 2010, 11:00 am")
        assert_equal expected, later
      end

      it "should take into account the weekend when subtracting a negative day" do
        first = Time.parse("April 12th, 2010, 12:33 pm")
        later = -1.business_day.before(first)
        expected = Time.parse("April 13th, 2010, 12:33 pm")
        assert_equal expected, later
      end

      it "should move forward one week when subtracting -5 business days" do
        first = Time.parse("April 9th, 2010, 12:33 pm")
        later = -5.business_days.before(first)
        expected = Time.parse("April 16th, 2010, 12:33 pm")
        assert_equal expected, later
      end

      it "should move to tuesday if we subtract one negative business day during a weekend" do
        saturday = Time.parse("April 10th, 2010, 11:00 am")
        later = -1.business_days.before(saturday)
        expected = Time.parse("April 13th, 2010, 09:00 am")
        assert_equal expected, later
      end

      it "should return a business hour when subtracting one negative business day from before business hours" do
        wednesday = Time.parse("Wednesday October 14th, 2015, 01:54 am")
        later = -1.business_days.before(wednesday)
        expected = Time.parse("Thurdsay October 15th, 2015, 09:00 am")
        assert later.during_business_hours?
        assert_equal expected, later
      end

      it "should return a business hour when subtracting one negative business day from after business hours" do
        wednesday = Time.parse("Wednesday October 14th, 2015, 21:54 pm")
        after = -1.business_days.before(wednesday)
        expected = Time.parse("Friday October 16th, 2015, 09:00 am")
        assert after.during_business_hours?
        assert_equal expected, after
      end
    end

    it "responds appropriatly to <" do
      assert 5.business_days < 10.business_days
      assert !(10.business_days < 5.business_days)

      assert -1.business_day < 1.business_day
      assert !(1.business_day < -1.business_day)
    end

    it "responds appropriatly to >" do
      assert !(5.business_days > 10.business_days)
      assert 10.business_days > 5.business_days

      assert 1.business_day > -1.business_day
      assert !(-1.business_day > 1.business_day)
    end

    it "responds appropriatly to ==" do
      assert 5.business_days == 5.business_days
      assert 10.business_days != 5.business_days

      assert -1.business_day == -1.business_day
      assert -1.business_day != -5.business_days
    end

    it "won't compare days to hours" do
      assert_raises ArgumentError do
        5.business_days < 5.business_hours
      end
      assert_raises ArgumentError do
        -5.business_days < 5.business_hours
      end
    end
  end
end
