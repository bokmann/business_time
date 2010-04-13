require 'helper'

class TestBusinessDays < Test::Unit::TestCase
  
  should "move to tomorrow if we add a business day" do
    first = Time.parse("April 13th, 2010, 11:00 am")
    later = 1.business_day.after(first)
    expected = Time.parse("April 14th, 2010, 11:00 am")
    assert expected == later
  end
  
  should "move to yesterday is we subtract a business day"
  
  should "take into account the weekend when adding a day"
  
  should "move forward one week when adding 5 business days"
  
  should "take into account a holiday when adding a day"
  
  should "take into account a holiday on a weekend"
  
  should "take into account a holiday on a Monday"
  
  should "take into account a holiday on a Friday"
  
end