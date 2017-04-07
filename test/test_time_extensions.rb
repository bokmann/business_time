require File.expand_path('../helper', __FILE__)

describe "time extensions" do
  it "know a weekend day is not a workday" do
    assert( Time.parse("April 9, 2010 10:45 am").workday?)
    assert(!Time.parse("April 10, 2010 10:45 am").workday?)
    assert(!Time.parse("April 11, 2010 10:45 am").workday?)
    assert( Time.parse("April 12, 2010 10:45 am").workday?)
  end

  it "know a weekend day is not a workday (with a configured work week)" do
    BusinessTime::Config.work_week = %w[sun mon tue wed thu]
    assert( Time.parse("April 8, 2010 10:30am").weekday?)
    assert(!Time.parse("April 9, 2010 10:30am").weekday?)
    assert(!Time.parse("April 10, 2010 10:30am").weekday?)
    assert( Time.parse("April 11, 2010 10:30am").weekday?)
  end

  it "know a holiday is not a workday" do
    BusinessTime::Config.holidays << Date.parse("July 4, 2010")
    BusinessTime::Config.holidays << Date.parse("July 5, 2010")

    assert(!Time.parse("July 4th, 2010 1:15 pm").workday?)
    assert(!Time.parse("July 5th, 2010 2:37 pm").workday?)
  end


  it "know the beginning of the day for an instance" do
    first = Time.parse("August 17th, 2010, 11:50 am")
    expecting = Time.parse("August 17th, 2010, 9:00 am")
    assert_equal expecting, Time.beginning_of_workday(first)
  end

  it "know the end of the day for an instance" do
    first = Time.parse("August 17th, 2010, 11:50 am")
    expecting = Time.parse("August 17th, 2010, 5:00 pm")
    assert_equal expecting, Time.end_of_workday(first)
  end

  # ===================

  it "calculate business time between different times on the same date (clockwise)" do
    time_a = Time.parse('2012-02-01 10:00')
    time_b = Time.parse('2012-02-01 14:20')
    assert_equal time_a.business_time_until(time_b), 260.minutes
  end

  it "calculate business time between different times on the same date (counter clockwise)" do
    time_a = Time.parse('2012-02-01 10:00')
    time_b = Time.parse('2012-02-01 14:20')
    assert_equal time_b.business_time_until(time_a), -260.minutes
  end

  it "calculate business time only within business hours even if second endpoint is out of business time" do
    time_a = Time.parse('2012-02-01 10:00')
    time_b = Time.parse("2012-02-01 " + BusinessTime::Config.end_of_workday.to_s) + 24.minutes
    first_result = time_a.business_time_until(time_b)
    time_b = Time.parse('2012-02-01 '+ BusinessTime::Config.end_of_workday.to_s)
    second_result = time_a.business_time_until(time_b)
    assert_equal first_result, 7.hours
    assert_equal second_result, 7.hours
  end

  it "calculate business time only within business hours even if the first endpoint is out of business time" do
    time_a = Time.parse("2012-02-01 7:25")
    time_b = Time.parse("2012-02-01 15:30")
    first_result = time_a.business_time_until(time_b)
    assert_equal first_result, 390.minutes
  end

  it "return correct time between two consecutive days" do
    time_a = Time.parse('2012-02-01 10:00')
    time_b = Time.parse('2012-02-02 10:00')
    working_hours = BusinessTime::Config.end_of_workday - BusinessTime::Config.beginning_of_workday
    assert_equal time_a.business_time_until(time_b), working_hours
  end

  it "calculate proper timing if there are several days between" do
    time_a = Time.parse('2012-02-01 10:00')
    time_b = Time.parse('2012-02-09 11:00')
    duration_of_working_day = BusinessTime::Config.end_of_workday - BusinessTime::Config.beginning_of_workday
    assert_equal time_a.business_time_until(time_b), 6 * duration_of_working_day + 1.hour
    assert_equal time_b.business_time_until(time_a), -(6 * duration_of_working_day + 1.hour)
  end

  it "calculate proper duration even if the end date is on a weekend" do
    ticket_reported = Time.parse("February 3, 2012, 10:40 am")
    ticket_resolved = Time.parse("February 4, 2012, 10:40 am") #will roll over to Monday morning, 9:00am
    assert_equal ticket_reported.business_time_until(ticket_resolved), 6.hours + 20.minutes
  end

  it "knows if within business hours" do
    assert(Time.parse("2013-02-01 10:00").during_business_hours?)
    assert(!Time.parse("2013-02-01 5:00").during_business_hours?)
  end

  # =================== .roll_backward ======================

  it "roll to the end of the same day when after hours on a workday" do
    time = Time.parse("11pm UTC, Wednesday 9th May, 2012")
    workday_end = BusinessTime::Config.end_of_workday
    expected_time = Time.parse("#{workday_end} UTC, Wednesday 9th May, 2012")
    assert_equal Time.roll_backward(time), expected_time
  end

  it "roll to the end of the previous day when before hours on a workday" do
    time = Time.parse("04am UTC, Wednesday 9th May, 2012")
    workday_end = BusinessTime::Config.end_of_workday
    expected_time = Time.parse("#{workday_end} UTC, Tuesday 8th May, 2012")
    assert_equal Time.roll_backward(time), expected_time
  end

  it "rolls to the end of the previous workday on non-working days" do
    time = Time.parse("12pm UTC, Sunday 6th May, 2012")
    workday_end = BusinessTime::Config.end_of_workday
    expected_time = Time.parse("#{workday_end} UTC, Friday 4th May, 2012")
    assert_equal Time.roll_backward(time), expected_time
  end

  it "returns the given time during working hours" do
    time = Time.parse("12pm, Tuesday 8th May, 2012")
    assert_equal Time.roll_backward(time), time
  end

  it "respects work hours" do
    wednesday = Time.parse("December 22, 2010 12:00")
    saturday  = Time.parse("December 25, 2010 12:00")
    BusinessTime::Config.work_hours = {
      :wed=>["9:00","12:00"],
      :sat=>["13:00","14:00"]
    }
    assert_equal wednesday, Time.roll_backward(saturday)
  end
end
