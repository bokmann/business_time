require 'helper'

class TestConfig < Test::Unit::TestCase
  
  should "keep track of the start of the day" do
    assert_equal BusinessTime::Config.beginning_of_workday, "9:00 am"
    BusinessTime::Config.beginning_of_workday = "8:30 am"
    assert_equal BusinessTime::Config.beginning_of_workday, "8:30 am"
  end
  
  should "keep track of the end of the day" do
    assert_equal BusinessTime::Config.end_of_workday, "5:00 pm"
    BusinessTime::Config.end_of_workday = "5:30 pm"
    assert_equal BusinessTime::Config.end_of_workday, "5:30 pm"
  end
  
  should "keep track of holidays" do
    BusinessTime::Config.reset
    assert BusinessTime::Config.holidays.empty?
    daves_birthday = Date.parse("August 4th, 1969")
    BusinessTime::Config.holidays << daves_birthday
    assert BusinessTime::Config.holidays.include?(daves_birthday)
  end
  
end
