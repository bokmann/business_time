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
  

  def outsize_business_hours?
    before_business_hours? || after_business_hours? || !workday?
  end
  
  # rolls forward to the next beginning_of_workday
  # when the time is outside of business hours
  def roll_forward
    next_business_time = self
  
    if (before_business_hours? || !workday?)
      next_business_time = beginning_of_workday
    end
    
    if after_business_hours?
      next_business_time = beginning_of_workday + 1.day
    end
    
    while !next_business_time.workday?
      next_business_time = next_business_time + 1.day      
    end    

    next_business_time
  end
  
  private
  
  def before_business_hours?
    (self < self.beginning_of_workday)
  end
  
  def after_business_hours?
    (self > self.end_of_workday)
  end
  
end