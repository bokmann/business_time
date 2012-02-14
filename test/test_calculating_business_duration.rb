require 'helper'

class TestCalculatingBusinessDuration < Test::Unit::TestCase 
  should "properly calculate business duration over weekends" do
    friday = Date.parse("December 24, 2010")
    monday = Date.parse("December 27, 2010")
    assert_equal 1, friday.business_days_until(monday)
  end
  
  should "properly calculate business duration without weekends" do
    monday = Date.parse("December 20, 2010")
    wednesday = Date.parse("December 22, 2010")
    assert_equal 2, monday.business_days_until(wednesday)
  end
  
  should "properly calculate business duration with respect to holidays" do
    free_friday = Date.parse("December 17, 2010")
    wednesday = Date.parse("December 15,2010")
    monday = Date.parse("December 20, 2010")
    BusinessTime::Config.holidays << free_friday
    assert_equal 2, wednesday.business_days_until(monday)
  end
  
  should "properly calculate business days with respect to work_hours" do
    friday = Date.parse("December 24, 2010")
    monday = Date.parse("December 27, 2010")
    BusinessTime::Config.work_hours = {
      :fri=>["9:00","17:00"],
      :sat=>["10:00","15:00"]
    }
    assert_equal 2, friday.business_days_until(monday)
  end

  should "properly calculate business time with respect to work_hours" do
    friday = Time.parse("December 24, 2010 15:00")
    monday = Time.parse("December 27, 2010 11:00")
    BusinessTime::Config.work_hours = {
      :mon=>["9:00","17:00"],
      :fri=>["9:00","17:00"],
      :sat=>["10:00","15:00"]
    }
    assert_equal 9.hours, friday.business_time_until(monday)
  end

  should "properly calculate business time with respect to work_hours with some 00:24 days" do
    friday = Time.parse("December 24, 2010 15:00")
    monday = Time.parse("December 27, 2010 11:00")
    BusinessTime::Config.work_hours = {
      :mon=>["0:00","0:00"],
      :fri=>["0:00","0:00"],
      :sat=>["11:00","15:00"]
    }
    assert_equal 24.hours, friday.business_time_until(monday)
  end

  should "properly calculate business time with respect to work_hours with all 00:24" do
    friday = Time.parse("December 24, 2010 15:00")
    monday = Time.parse("December 27, 2010 11:00")
    BusinessTime::Config.work_hours = {
      :mon=>["0:00","0:00"],
      :fri=>["0:00","0:00"],
      :sat=>["00:00","00:00"],
      :sun=>["00:00","00:00"]
    }
    assert_equal 68.hours, friday.business_time_until(monday)
  end
end