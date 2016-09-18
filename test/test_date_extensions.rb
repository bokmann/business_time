require File.expand_path('../helper', __FILE__)

describe "date extensions" do
  it "know a weekend day is not a workday"  do
    assert(Date.parse("April 9, 2010").workday?)
    assert(!Date.parse("April 9, 2010").non_working_day?)

    assert(!Date.parse("April 10, 2010").workday?)
    assert(Date.parse("April 10, 2010").non_working_day?)

    assert(!Date.parse("April 11, 2010").workday?)
    assert(Date.parse("April 11, 2010").non_working_day?)

    assert(Date.parse("April 12, 2010").workday?)
    assert(!Date.parse("April 12, 2010").non_working_day?)
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
    assert(july_4.non_working_day?)

    assert(july_5.workday?)
    assert(!july_5.non_working_day?)

    BusinessTime::Config.holidays << july_4
    BusinessTime::Config.holidays << july_5

    assert(!july_4.workday?)
    assert(july_4.non_working_day?)

    assert(!july_5.workday?)
    assert(july_5.non_working_day?)
  end
end
