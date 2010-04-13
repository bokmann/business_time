require 'helper'

class TestDateExtensions < Test::Unit::TestCase
  
  should "know what a weekend day is"  do
    assert(Time.parse("April 9, 2010").weekday?)
    assert(!Time.parse("April 10, 2010").weekday?)
    assert(!Time.parse("April 11, 2010").weekday?)
    assert(Time.parse("April 12, 2010").weekday?)
  end
  
  should "know a weekend day is not a workday"
  
  should "know a holiday is not a workday"
  
end