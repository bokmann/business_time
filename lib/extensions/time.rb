# Add workday and weekday concepts to the Time class
class Time

  # You must use this method to set the timezone before calling any other
  # methods defined below!
  def timezone_fix(timezone)
    @timezone = timezone
  end

  # There are bugs in ActiveSupport::TimeWithZone involving timezone support.
  # This is a workaround until these issues are resolved.
  #
  # Call this methods before calling any native TimeWithZone methods to prevent
  # harmful mutations to the TimeWithZone object.
  def self_with_zone
    t = asctime.sub(/#{year}$/, "#{@timezone} #{year}")
    Time.zone.parse t
  end

  # Gives the time at the end of the workday, assuming that this time falls on a
  # workday.
  # Note: It pretends that this day is a workday whether or not it really is a
  # workday.
  def end_of_workday
    Time.zone.parse self_with_zone.strftime(
        "%B %d %Y #{BusinessTime::Config.end_of_workday}")  
  end
  
  # Gives the time at the beginning of the workday, assuming that this time
  # falls on a workday.
  # Note: It pretends that this day is a workday whether or not it really is a
  # workday.
  def beginning_of_workday
    Time.zone.parse self_with_zone.strftime(
        "%B %d %Y #{BusinessTime::Config.beginning_of_workday}")
  end
  
  # True if this time is on a workday (between 00:00:00 and 23:59:59), even if
  # this time falls outside of normal business hours.
  def workday?
    weekday? && 
        !BusinessTime::Config.holidays.include?(self_with_zone.to_date)
  end
  
  # True if this time falls on a weekday.
  def weekday?
    [1,2,3,4,5].include? self_with_zone.wday
  end

  def before_business_hours?
    self_with_zone < beginning_of_workday
  end
  
  def after_business_hours?
    self_with_zone > end_of_workday
  end
  
  # Rolls forward to the next beginning_of_workday
  # when the time is outside of business hours
  def roll_forward
    next_business_time = self_with_zone
  
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
  
end
