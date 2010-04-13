# Add workday and weekday concepts to the Date class
class Date
  def workday?
    self.weekday? && !BusinessTime::Config.holidays.include?(self)
  end
  
  def weekday?
    [1,2,3,4,5].include? self.wday
  end
end