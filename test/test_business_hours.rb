require File.expand_path('../helper', __FILE__)

describe "business hours" do
  describe "with a standard Time object" do
    describe "when adding/subtracting positive number of business hours" do
      it "move to tomorrow if we add 8 business hours" do
        first = Time.parse("Aug 4 2010, 9:35 am")
        later = 8.business_hours.after(first)
        expected = Time.parse("Aug 5 2010, 9:35 am")
        assert_equal expected, later
      end

      it "move to yesterday if we subtract 8 business hours" do
        first = Time.parse("Aug 4 2010, 9:35 am")
        before = 8.business_hours.before(first)
        expected = Time.parse("Aug 3 2010, 9:35 am")
        assert_equal expected, before
      end

      it "take into account a weekend when adding an hour" do
        friday_afternoon = Time.parse("April 9th 2010, 4:50 pm")
        monday_morning = 1.business_hour.after(friday_afternoon)
        expected = Time.parse("April 12th 2010, 9:50 am")
        assert_equal expected, monday_morning
      end

      it "picks next working day when adding zero hours on weekends" do
        first = Time.parse("April 10th, 2010, 12:33 pm")
        after = 0.business_hours.after(first)
        expected = Time.parse("April 12th, 2010, 9:00 am")
        assert_equal expected, after
      end

      it "should pick previous working day when subtracting zero hours on the weekend" do
        first = Time.parse("January 30th, 2016, 12:33 pm")
        after = 0.business_hours.before(first)
        expected = Time.parse("January 29th, 2016, 17:00 pm")
        assert_equal expected, after
      end

      it "take into account a weekend when adding an hour, using the common interface #since" do
        friday_afternoon = Time.parse("April 9th 2010, 4:50 pm")
        monday_morning = 1.business_hour.since(friday_afternoon)
        expected = Time.parse("April 12th 2010, 9:50 am")
        assert_equal expected, monday_morning
      end

      it "take into account a weekend when subtracting an hour" do
        monday_morning = Time.parse("April 12th 2010, 9:50 am")
        friday_afternoon = 1.business_hour.before(monday_morning)
        expected = Time.parse("April 9th 2010, 4:50 pm")
        assert_equal expected, friday_afternoon
      end

      it "take into account a holiday" do
        BusinessTime::Config.holidays << Date.parse("July 5th, 2010")
        friday_afternoon = Time.parse("July 2nd 2010, 4:50pm")
        tuesday_morning = 1.business_hour.after(friday_afternoon)
        expected = Time.parse("July 6th 2010, 9:50 am")
        assert_equal expected, tuesday_morning
      end

      it "add hours in the middle of the workday"  do
        monday_morning = Time.parse("April 12th 2010, 9:50 am")
        later = 3.business_hours.after(monday_morning)
        expected = Time.parse("April 12th 2010, 12:50 pm")
        assert_equal expected, later
      end

      it "roll forward to 9 am if asked in the early morning" do
        crack_of_dawn_monday = Time.parse("Mon Apr 26, 04:30:00, 2010")
        monday_morning = Time.parse("Mon Apr 26, 09:00:00, 2010")
        assert_equal monday_morning, Time.roll_forward(crack_of_dawn_monday)
      end

      it "roll forward to the next morning if aftern business hours" do
        monday_evening = Time.parse("Mon Apr 26, 18:00:00, 2010")
        tuesday_morning = Time.parse("Tue Apr 27, 09:00:00, 2010")
        assert_equal tuesday_morning, Time.roll_forward(monday_evening)
      end

      it "get the first business after the time that is not a business hour" do
        saturday = Time.parse("Sat Aug 9, 18:00:00, 2014")
        monday = Time.parse("Mon Aug 11, 18:00:00, 2014")
        assert_equal monday, Time.first_business_day(saturday)
      end

      it "get the time itself if it is a business hour" do
        monday = Time.parse("Mon Aug 11, 18:00:00, 2014")
        assert_equal monday, Time.first_business_day(monday)
      end

      it "get the first business day before the time that is not a business hour" do
        saturday = Time.parse("Sat Aug 9, 18:00:00, 2014")
        friday   = Time.parse("Fri Aug 8, 18:00:00, 2014")
        assert_equal friday, Time.previous_business_day(saturday)
      end

      it "get the time itself if it is a business hour" do
        monday = Time.parse("Mon Aug 11, 18:00:00, 2014")
        assert_equal monday, Time.previous_business_day(monday)
      end

      it "consider any time on a weekend as equivalent to monday morning" do
        sunday = Time.parse("Sun Apr 25 12:06:56, 2010")
        monday = Time.parse("Mon Apr 26, 09:00:00, 2010")
        assert_equal 1.business_hour.before(monday), 1.business_hour.before(sunday)
      end

      it "respect work_hours" do
        friday = Time.parse("December 24, 2010 15:00")
        monday = Time.parse("December 27, 2010 11:00")
        BusinessTime::Config.work_hours = {
          :mon=>["9:00","17:00"],
          :fri=>["9:00","17:00"],
          :sat=>["10:00","15:00"]
        }
        assert_equal monday, 9.business_hours.after(friday)
        assert_equal friday, 9.business_hours.before(monday)
      end

      it "respect work_hours when starting before beginning of workday" do
        friday = Time.parse("December 24, 2010 08:00")
        monday = Time.parse("December 27, 2010 11:00")
        BusinessTime::Config.work_hours = {
          :mon=>["9:00","17:00"],
          :fri=>["9:00","17:00"],
          :sat=>["10:00","15:00"]
        }
        assert_equal monday, 15.business_hours.after(friday)
        assert_equal friday + 1.hour, 15.business_hours.before(monday)
      end

      it "respect work_hours with some 24 hour days" do
        friday = Time.parse("December 24, 2010 15:00")
        monday = Time.parse("December 27, 2010 11:00")
        BusinessTime::Config.work_hours = {
          :mon=>["0:00","0:00"],
          :fri=>["0:00","0:00"],
          :sat=>["11:00","15:00"]
        }
        assert_equal monday, 24.business_hours.after(friday)
        assert_equal friday, 24.business_hours.before(monday)
      end

      it "respect work_hours within same day" do
        friday_start = Time.parse("December 24, 2010 8:00")
        friday_end   = Time.parse("December 24, 2010 17:00")
        BusinessTime::Config.work_hours = {
          :fri=>["9:00","17:00"]
        }
        assert_equal friday_end, 8.business_hours.after(friday_start)
        assert_equal friday_start + 1.hours, 8.business_hours.before(friday_end)
      end

      it "respect work_hours with some 24 hour days when starting before beginning of workday" do
        saturday = Time.parse("December 25, 2010 08:00")
        monday = Time.parse("December 27, 2010 11:00")
        BusinessTime::Config.work_hours = {
          :mon=>["0:00","0:00"],
          :fri=>["0:00","0:00"],
          :sat=>["11:00","15:00"]
        }
        assert_equal monday, 15.business_hours.after(saturday)
        assert_equal saturday + 3.hours, 15.business_hours.before(monday)
      end

      it "take into account a holiday passed as an option" do
        three_day_weekend = Date.parse("July 5th, 2010")
        friday_afternoon = Time.parse("July 2nd 2010, 4:50pm")
        tuesday_morning = 1.business_hour.after(friday_afternoon, holidays: [three_day_weekend])
        expected = Time.parse("July 6th 2010, 9:50 am")
        assert_equal expected, tuesday_morning
      end
    end

    describe "when adding/subtracting negative number of business hours" do
      it "move to yesterday if we add -8 business hours" do
        first = Time.parse("Aug 5 2010, 9:35 am")
        before = -8.business_hours.after(first)
        expected = Time.parse("Aug 4 2010, 9:35 am")
        assert_equal expected, before
      end

      it "move to tomorrow if we subtract -8 business hours" do
        first = Time.parse("Aug 3 2010, 9:35 am")
        later = -8.business_hours.before(first)
        expected = Time.parse("Aug 4 2010, 9:35 am")
        assert_equal expected, later
      end

      it "take into account a weekend when adding a negative hour" do
        monday_morning = Time.parse("April 12th 2010, 9:50 am")
        friday_afternoon = -1.business_hour.after(monday_morning)
        expected = Time.parse("April 9th 2010, 4:50 pm")
        assert_equal expected, friday_afternoon
      end

      it "take into account a weekend when adding a negative hour, using the common interface #since" do
        monday_morning = Time.parse("April 12th 2010, 9:50 am")
        friday_afternoon = -1.business_hour.since(monday_morning)
        expected = Time.parse("April 9th 2010, 4:50 pm")
        assert_equal expected, friday_afternoon
      end

      it "take into account a weekend when subtracting a negative hour" do
        friday_afternoon = Time.parse("April 9th 2010, 4:50 pm")
        monday_morning = -1.business_hour.before(friday_afternoon)
        expected = Time.parse("April 12th 2010, 9:50 am")
        assert_equal expected, monday_morning
      end

      it "take into account a holiday" do
        BusinessTime::Config.holidays << Date.parse("July 5th, 2010")
        tuesday_morning = Time.parse("July 6nd 2010, 9:50 am")
        friday_afternoon = -1.business_hour.after(tuesday_morning)
        expected = Time.parse("July 2th 2010, 4:50 pm")
        assert_equal expected, friday_afternoon
      end

      it "add negative hours in the middle of the workday"  do
        monday_afternoon = Time.parse("April 12th 2010, 12:50 pm")
        before = -3.business_hours.after(monday_afternoon)
        expected = Time.parse("April 12th 2010, 9:50 am")
        assert_equal expected, before
      end

      it "consider any time on a weekend as equivalent to monday morning" do
        sunday = Time.parse("Sun Apr 25 12:06:56, 2010")
        monday = Time.parse("Mon Apr 26, 09:00:00, 2010")
        assert_equal -1.business_hour.before(monday), -1.business_hour.before(sunday)
      end

      it "respect work_hours" do
        friday = Time.parse("December 24, 2010 15:00")
        monday = Time.parse("December 27, 2010 11:00")
        BusinessTime::Config.work_hours = {
          :mon=>["9:00","17:00"],
          :fri=>["9:00","17:00"],
          :sat=>["10:00","15:00"]
        }
        assert_equal friday, -9.business_hours.after(monday)
        assert_equal monday, -9.business_hours.before(friday)
      end

      it "respect work_hours when starting before beginning of workday" do
        friday = Time.parse("December 24, 2010 08:00")
        monday = Time.parse("December 27, 2010 11:00")
        BusinessTime::Config.work_hours = {
          :mon=>["9:00","17:00"],
          :fri=>["9:00","17:00"],
          :sat=>["10:00","15:00"]
        }
        assert_equal friday + 1.hour, -15.business_hours.after(monday)
        assert_equal monday, -15.business_hours.before(friday)
      end

      it "respect work_hours with some 24 hour days" do
        friday = Time.parse("December 24, 2010 15:00")
        monday = Time.parse("December 27, 2010 11:00")
        BusinessTime::Config.work_hours = {
          :mon=>["0:00","0:00"],
          :fri=>["0:00","0:00"],
          :sat=>["11:00","15:00"]
        }
        assert_equal friday, -24.business_hours.after(monday)
        assert_equal monday, -24.business_hours.before(friday)
      end

      it "respect work_hours within same day" do
        friday_start = Time.parse("December 24, 2010 8:00")
        friday_end   = Time.parse("December 24, 2010 17:00")
        BusinessTime::Config.work_hours = {
          :fri=>["9:00","17:00"]
        }
        assert_equal friday_start + 1.hour, -8.business_hours.after(friday_end)
        assert_equal friday_end, -8.business_hours.before(friday_start)
      end

      it "respect work_hours with some 24 hour days when starting before beginning of workday" do
        saturday = Time.parse("December 25, 2010 08:00")
        monday = Time.parse("December 27, 2010 11:00")
        BusinessTime::Config.work_hours = {
          :mon=>["0:00","0:00"],
          :fri=>["0:00","0:00"],
          :sat=>["11:00","15:00"]
        }
        assert_equal saturday + 3.hours, -15.business_hours.after(monday)
        assert_equal monday, -15.business_hours.before(saturday)
      end

      it "take into account a holiday passed as an option" do
        three_day_weekend = Date.parse("July 5th, 2010")
        tuesday_morning = Time.parse("July 6nd 2010, 9:50 am")
        friday_afternoon = -1.business_hour.after(tuesday_morning, holidays: [three_day_weekend])
        expected = Time.parse("July 2th 2010, 4:50 pm")
        assert_equal expected, friday_afternoon
      end


    end

    it "responds appropriatly to <" do
      assert 5.business_hours < 10.business_hours
      assert !(10.business_hours < 5.business_hours)

      assert -10.business_hours < -5.business_hours
      assert !(-5.business_hours < -10.business_hours)

      assert -5.business_hours < 5.business_hours
      assert !(5.business_hours < -5.business_hours)
    end

    it "responds appropriatly to >" do
      assert !(5.business_hours > 10.business_hours)
      assert 10.business_hours > 5.business_hours

      assert !(-10.business_hours > -5.business_hours)
      assert -5.business_hours > -10.business_hours

      assert !(-5.business_hours > 5.business_hours)
      assert 5.business_hours > -5.business_hours
    end

    it "responds appropriatly to ==" do
      assert 5.business_hours == 5.business_hours
      assert 10.business_hours != 5.business_hours

      assert -5.business_hours == -5.business_hours
      assert -5.business_hours != -10.business_hours

      assert -5.business_hours != 5.business_hours
    end

    it "won't compare hours and days" do
      assert_raises ArgumentError do
        5.business_hours < 5.business_days
      end
      assert_raises ArgumentError do
        -5.business_hours < -5.business_days
      end
    end

  end
end
