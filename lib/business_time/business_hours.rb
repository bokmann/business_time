module BusinessTime

  class BusinessHours
    def initialize(hours)
      @hours = hours
    end
    
    def ago
      before(Time.now)
    end
    
    def from_now
      after(Time.now)
    end
     
    def after(time)
      time = time.roll_forward
      @hours.times do 
        time = time + 1.hour  #add an hour
        
        if (time > time.end_of_workday)
          time = time + off_hours  # if that pushes us past business hours,
        end                        # roll into the next day
        
        while !time.workday?
          time = time + 1.day      # if that pushes us into a non-business day,
        end                        # find the next business day
      end
      time
    end
            
    def before(time)
      time = time.roll_forward
      @hours.times do 
        time = time - 1.hour  #subtract an hour
        
        if (time < time.beginning_of_workday)
          time = time - off_hours  # if that pushes us before business hours,
        end                        # roll into the previous day
        
        while !time.workday?
          time = time - 1.day      # if that pushes us into a non-business day,
        end                        # find the previous business day
      end
      time
    end
    
    private
    
    def off_hours
      @gap ||= Time.parse(BusinessTime::Config.beginning_of_workday) - 
              (Time.parse(BusinessTime::Config.end_of_workday) - 1.day)
    end
  end
  
end