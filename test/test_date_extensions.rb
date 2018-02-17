require File.expand_path('../helper', __FILE__)

describe "date extensions" do
  it "know a weekend day is not a workday"  do
    assert(Date.parse("April 9, 2010").workday?)
    assert(!Date.parse("April 10, 2010").workday?)
    assert(!Date.parse("April 11, 2010").workday?)
    assert(Date.parse("April 12, 2010").workday?)
  end

  it "know a weekend day is not a workday (with a configured work week)"  do
    BusinessTime::Config.work_week = %w[sun mon tue wed thu]
    assert(Date.parse("April 8, 2010").weekday?)
    assert(!Date.parse("April 9, 2010").weekday?)
    assert(!Date.parse("April 10, 2010").weekday?)
    assert(Date.parse("April 12, 2010").weekday?)
  end

  it "know a holiday is not a workday" do
    july_4 = Date.parse("July 4, 2010")
    july_5 = Date.parse("July 5, 2010")

    assert(!july_4.workday?)
    assert(july_5.workday?)

    BusinessTime::Config.holidays << july_4
    BusinessTime::Config.holidays << july_5

    assert(!july_4.workday?)
    assert(!july_5.workday?)
  end

  it "#week" do
    assert_equal  1, Date.parse("Jan 1, 2017").week
    assert_equal  1, Date.parse("Jan 7, 2017").week
    assert_equal  2, Date.parse("Jan 8, 2017").week
    assert_equal 51, Date.parse("Dec 23, 2017").week
    assert_equal 52, Date.parse("Dec 24, 2017").week
    assert_equal 52, Date.parse("Dec 31, 2017").week # There is no 53rd week
  end

  it "#quarter" do
    assert_equal 1, Date.parse("Jan 1, 2017").quarter
    assert_equal 1, Date.parse("Mar 31, 2017").quarter
    assert_equal 2, Date.parse("Apr 1, 2017").quarter
    assert_equal 4, Date.parse("Dec 31, 2017").quarter
  end

  it "#fiscal_year_week" do
    assert_equal 52, Date.parse("Sep 30, 2017").fiscal_year_week # There is no 53rd week
    assert_equal  1, Date.parse("Oct 1, 2017").fiscal_year_week
    assert_equal  5, Date.parse("Nov 1, 2017").fiscal_year_week
    assert_equal  9, Date.parse("Dec 1, 2017").fiscal_year_week
    assert_equal 14, Date.parse("Jan 1, 2017").fiscal_year_week

    BusinessTime::Config.fiscal_month_offset = 7 # Australia
    assert_equal 1, Date.parse("Jul 1, 2017").fiscal_year_week
  end

  it "#fiscal_year_quarter" do
    assert_equal 4, Date.parse("Sep 30, 2017").fiscal_year_quarter
    assert_equal 1, Date.parse("Oct 1, 2017").fiscal_year_quarter
    assert_equal 4, Date.parse("Sep 30, 2018").fiscal_year_quarter

    BusinessTime::Config.fiscal_month_offset = 7 # Australia
    assert_equal 4, Date.parse("Jun 30, 2017").fiscal_year_quarter
    assert_equal 1, Date.parse("Jul 1, 2017").fiscal_year_quarter
  end

  it "#fiscal_year" do
    assert_equal 2017, Date.parse("Sep 30, 2017").fiscal_year
    assert_equal 2018, Date.parse("Oct 1, 2017").fiscal_year
    assert_equal 2018, Date.parse("Sep 30, 2018").fiscal_year

    BusinessTime::Config.fiscal_month_offset = 7 # Australia
    assert_equal 2017, Date.parse("Jun 30, 2017").fiscal_year
    assert_equal 2018, Date.parse("Jul 1, 2017").fiscal_year
  end

  it "#fiscal_year_yday" do
    assert_equal 365, Date.parse("Sep 30, 2017").fiscal_year_yday
    assert_equal   1, Date.parse("Oct 1, 2017").fiscal_year_yday
    assert_equal  92, Date.parse("Dec 31, 2017").fiscal_year_yday

    BusinessTime::Config.fiscal_month_offset = 7 # Australia
    assert_equal 365, Date.parse("Jun 30, 2017").fiscal_year_yday
    assert_equal   1, Date.parse("Jul 1, 2017").fiscal_year_yday
  end

  it "know a holiday is not a workday when passed as options" do
    july_4 = Date.parse("July 4, 2010")
    july_5 = Date.parse("July 5, 2010")

    assert(!july_4.workday?)
    assert(july_5.workday?)

    assert(!july_4.workday?(holidays: [july_4]))
    assert(!july_5.workday?(holidays: [july_5]))
  end

end
