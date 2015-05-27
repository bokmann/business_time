module BusinessTime
  class BusinessDays
    def initialize(days)
      @days = days
    end

    def after(time = Time.current)
      days = @days
      while days > 0 || !time.workday?
        time = time + 1.day
        days -= 1 if time.workday?
      end
      time
    end

    alias_method :from_now, :after
    alias_method :since, :after

    def before(time = Time.current)
      days = @days
      while days > 0 || !time.workday?
        time = time - 1.day
        days -= 1 if time.workday?
      end
      time
    end

    alias_method :ago, :before
    alias_method :until, :before
  end
end
