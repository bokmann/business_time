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
  
end