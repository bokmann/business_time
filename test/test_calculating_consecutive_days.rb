require File.expand_path('../helper', __FILE__)

describe 'calculating consecutive workdays' do
  it 'return empty array if object is not a workday' do
    sunday = Date.parse("December 26, 2010")
    sunday.consecutive_workdays.must_equal []
  end

  it 'return array with self if preceded and followed by non-working days' do
    free_thursday = Date.parse("December 16, 2010")
    friday = Date.parse("December 17, 2010")
    BusinessTime::Config.holidays << free_thursday
    assert_equal [friday], friday.consecutive_workdays
  end

  it 'return an array of consecutive workdays sorted by date' do
    friday = Date.parse("December 17, 2010")
    weekdays = [Date.parse("December 13, 2010"),
                Date.parse("December 14, 2010"),
                Date.parse("December 15, 2010"),
                Date.parse("December 16, 2010"),
                friday]
    assert_equal weekdays, friday.consecutive_workdays
  end
end

describe 'calculating consecutive non-working days' do
  it 'return empty array if object is not a non-working day' do
    monday = Date.parse("December 13, 2010")
    monday.consecutive_non_working_days.must_equal []
  end

  it 'return array with self if preceded and followed by workdays' do
    free_thursday = Date.parse("December 16, 2010")
    BusinessTime::Config.holidays << free_thursday
    assert_equal [free_thursday], free_thursday.consecutive_non_working_days
  end

  it 'return an array of consecutive non-working days sorted by date' do
    sunday = Date.parse("December 19, 2010")
    free_friday = Date.parse("December 17, 2010")
    BusinessTime::Config.holidays << free_friday
    firday_plus_weekend = [free_friday,
                           Date.parse("December 18, 2010"),
                           sunday]
    assert_equal firday_plus_weekend, sunday.consecutive_non_working_days
  end

  it 'return array with self if preceded and followed by non-working days with holidays as options' do
    free_thursday = Date.parse("December 16, 2010")
    friday = Date.parse("December 17, 2010")
    assert_equal [friday], friday.consecutive_workdays(holidays: [free_thursday])
  end

  it 'return array with self if preceded and followed by workdays with holidays as options' do
    free_thursday = Date.parse("December 16, 2010")
    assert_equal [free_thursday], free_thursday.consecutive_non_working_days(holidays: [free_thursday])
  end

  it 'return an array of consecutive non-working days sorted by date with holidays as options' do
    sunday = Date.parse("December 19, 2010")
    free_friday = Date.parse("December 17, 2010")
    firday_plus_weekend = [free_friday,
                           Date.parse("December 18, 2010"),
                           sunday]
    assert_equal firday_plus_weekend, sunday.consecutive_non_working_days(holidays: [free_friday])
  end

end
