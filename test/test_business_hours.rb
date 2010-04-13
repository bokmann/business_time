require 'helper'

class TestBusinessHours < Test::Unit::TestCase
  should "move to tomorrow if we add 8 business hours" do
    first = Time.parse("Aug 4 2010, 9:35 am")
    later = 8.business_hours.after(first)
    expected = Time.parse("Aug 5 2010, 9:35 am")
  end
  
  should "move to yesterday is we subtract 8 business hours"
  
  should "take into account a weekend"
  
  should "take into account a holiday"
  
  should "add hours in the middle of the workday"
  
  should "wrap to tomorrow if past the end of the workday"
  
  should "wrap to yesterday if past the beginning of the workday"
  
end
