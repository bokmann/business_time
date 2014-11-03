require 'active_support/time'

module BusinessTime
  
  class BusinessDays
    def initialize(days)
      @days = days
    end

    def now
      BusinessTime::Config.time_zone ? BusinessTime::Config.time_zone.now : Time.now
    end

    def after(time = now)
      time = BusinessTime::Config.time_zone ? BusinessTime::Config.time_zone.parse(time.strftime('%Y-%m-%d %H:%M:%S %z')) : Time.parse(time.strftime('%Y-%m-%d %H:%M:%S %z'))
      days = @days
      while days > 0 || !Time.workday?(time)
        days -= 1 if Time.workday?(time)
        time = time + 1.day
      end
      time
    end
    
    alias_method :from_now, :after
    alias_method :since, :after
    
    def before(time = now)
      time = BusinessTime::Config.time_zone ? BusinessTime::Config.time_zone.parse(time.rfc822) : Time.parse(time.rfc822)
      days = @days
      while days > 0 || !Time.workday?(time)
        days -= 1 if Time.workday?(time)
        time = time - 1.day
      end
      time
    end
    
    alias_method :ago, :before
    alias_method :until, :before
  
  end  
  
end
