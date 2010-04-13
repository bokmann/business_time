require 'helper'

class TestDateExtensions < Test::Unit::TestCase
  
  should "know what a weekend day is"  do
    assert(Date.parse("April 9, 2010").weekday?)
    assert(!Date.parse("April 10, 2010").weekday?)
    assert(!Date.parse("April 11, 2010").weekday?)
    assert(Date.parse("April 12, 2010").weekday?)
  end
  
  should "know a weekend day is not a workday"  do
    assert(Date.parse("April 9, 2010").workday?)
    assert(!Date.parse("April 10, 2010").workday?)
    assert(!Date.parse("April 11, 2010").workday?)
    assert(Date.parse("April 12, 2010").workday?)
  end
  
  should "know a holiday is not a workday" do
    july_4 = Date.parse("July 4, 2010")
    july_5 = Date.parse("July 5, 2010")
    
    assert(!july_4.workday?)
    assert(july_5.workday?)
    
    BusinessTime::Config.holidays << july_4
    BusinessTime::Config.holidays << july_5
    
    assert(!july_4.workday?)
    assert(!july_5.workday?)
  end
  
end