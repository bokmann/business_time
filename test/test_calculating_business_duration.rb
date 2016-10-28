require File.expand_path('../helper', __FILE__)

describe "calculating business duration" do
  it "properly calculate business duration" do
    monday = Date.parse("December 20, 2010")
    wednesday = Date.parse("December 22, 2010")
    assert_equal 2, monday.business_days_until(wednesday)
  end

  it "can calculate exclusive business duration" do
    monday = Date.parse("December 20, 2010")
    wednesday = Date.parse("December 22, 2010")
    assert_equal 2, monday.business_days_until(wednesday, false)
  end

  it "can calculate inclusive business duration" do
    monday = Date.parse("December 20, 2010")
    wednesday = Date.parse("December 22, 2010")
    assert_equal 3, monday.business_days_until(wednesday, true)
  end

  it "can calculate inclusive business duration over weekends" do
    sunday = Date.parse("November 15, 2015")
    friday = Date.parse("November 20, 2015")
    assert_equal 5, sunday.business_days_until(friday, true)
  end

  it "properly calculate business time with respect to work_hours" do
    friday = Time.parse("December 24, 2010 15:00")
    monday = Time.parse("December 27, 2010 11:00")
    BusinessTime::Config.work_hours = {
        :mon => ["9:00", "17:00"],
        :fri => ["9:00", "17:00"],
        :sat => ["10:00", "15:00"]
    }
    assert_equal 9.hours, friday.business_time_until(monday)
  end

  it "properly calculate business time with respect to work_hours with UTC time zone" do
    Time.zone = 'UTC'

    monday = Time.zone.parse("May 28 11:04:26 +0300 2012")
    tuesday = Time.zone.parse("May 29 17:56:45 +0300 2012")
    BusinessTime::Config.work_hours = {
        :mon => ["9:00", "18:00"],
        :tue => ["9:00", "18:00"],
        :wed => ["9:00", "18:00"]
    }
    assert_equal 53805.0, monday.business_time_until(tuesday)
    Time.zone = nil
  end

  it "properly calculate business time with respect to work_hours some 00:24 days" do
    friday = Time.parse("December 24, 2010 15:00")
    monday = Time.parse("December 27, 2010 11:00")
    BusinessTime::Config.work_hours = {
        :mon => ["0:00", "0:00"],
        :fri => ["0:00", "0:00"],
        :sat => ["11:00", "15:00"]
    }
    assert_equal 24.hours, friday.business_time_until(monday)
  end

  it "properly calculate business time with respect to work_hours with all days as 00:24" do
    friday = Time.parse("December 24, 2010 15:00")
    monday = Time.parse("December 27, 2010 11:00")
    BusinessTime::Config.work_hours = {
        :mon => ["00:00", "00:00"],
        :fri => ["00:00", "00:00"],
        :sat => ["00:00", "00:00"],
        :sun => ["00:00", "00:00"]
    }
    assert_equal 68.hours, friday.business_time_until(monday)
  end

  it 'properly calculate overnight business time' do
    BusinessTime::Config.work_hours = {
        mon: ["08:00", "20:00"],
        tue: ["08:00", "20:00"],
    }
    BusinessTime::Config.holidays = []

    created_at = Time.local(2014, 05, 12, 20, 50) #yesterday night 20:50
    published_at = Time.local(2014, 05, 13, 8, 10) #today morning 08:10
    assert created_at.monday?
    assert published_at.tuesday?

    assert_equal 10.minutes, created_at.business_time_until(published_at)
  end
end
