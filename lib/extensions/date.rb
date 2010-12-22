# Add workday and weekday concepts to the Date class
class Date
  def workday?
    self.weekday? && !BusinessTime::Config.holidays.include?(self)
  end
  
  def weekday?
    [1,2,3,4,5].include? self.wday
  end
  
  def business_days_until(to_date)
    (self...to_date).select{ |day| day.workday? }.size
  end
end
