require 'helper'

class TestCalculatingBusinessDuration < Test::Unit::TestCase 
  should "properly calculate business duration over weekends" do
    friday = Date.parse("December 24, 2010")
    monday = Date.parse("December 27, 2010")
    assert_equal friday.business_days_until(monday), 1
  end
  
  should "properly calculate business duration without weekends" do
    monday = Date.parse("December 20, 2010")
    wednesday = Date.parse("December 22, 2010")
    assert_equal monday.business_days_until(wednesday), 2
  end
  
  should "properly calculate business duration with respect to holidays" do
    free_friday = Date.parse("December 17, 2010")
    wednesday = Date.parse("December 15,2010")
    monday = Date.parse("December 20, 2010")
    BusinessTime::Config.holidays << free_friday
    assert_equal wednesday.business_days_until(monday), 2
  end
  
end