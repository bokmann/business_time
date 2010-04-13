module BusinessTime

  class BusinessDays
    def initialize(days)
      @days = days
    end

    def ago
      before(Time.now)
    end

    def from_now
      after(Time.now)
    end

    def after(time)
      @days.times do
        begin
          time = time + 1.day
        end until time.workday?
      end
      time
    end

    def before(time)
      @days.times do
        begin
          time = time - 1.day
        end until time.workday?
      end
      time
    end
  end  
  
end