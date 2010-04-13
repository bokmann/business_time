# Add workday and weekday concepts to the Time class
class Time
  def end_of_workday
    Time.parse self.strftime("%B %d %Y #{BusinessTime::Config.end_of_workday}")  
  end
  
  def beginning_of_workday
    Time.parse self.strftime("%B %d %Y #{BusinessTime::Config.beginning_of_workday}")
  end
  
  def workday?
    self.weekday? && !BusinessTime::Config.holidays.include?(self.to_date)
  end
  
  def weekday?
    [1,2,3,4,5].include? self.wday
  end
end