require 'helper'

class TestTimeExtensions < Test::Unit::TestCase
  
  should "know what a weekend day is" do
    assert(Time.parse("April 9, 2010 10:30am").weekday?)
    assert(!Time.parse("April 10, 2010 10:30am").weekday?)
    assert(!Time.parse("April 11, 2010 10:30am").weekday?)
    assert(Time.parse("April 12, 2010 10:30am").weekday?)
  end
  
  should "know a weekend day is not a workday"
  
  should "know a holiday is not a workday"
  
  should "know the beginning of the day for an instance"
  
  should "know the end of the day for an instance"
  
end