require 'active_support/time'

module BusinessTime
  class BusinessDays
    include Comparable
    attr_reader :days
    
    def initialize(days)
      @days = days
    end

    def <=>(other)
      if other.class != self.class
        raise ArgumentError.new("#{self.class.to_s} can't be compared with #{other.class.to_s}")
      end
      self.days <=> other.days
    end
    
    def after(time = Time.current)
      days = @days
      while days > 0 || !time.workday?
        days -= 1 if time.workday?
        time = time + 1.day
      end
      time
    end

    alias_method :from_now, :after
    alias_method :since, :after

    def before(time = Time.current)
      days = @days
      while days > 0 || !time.workday?
        days -= 1 if time.workday?
        time = time - 1.day
      end
      time
    end
    
    alias_method :ago, :before
    alias_method :until, :before
  end
end
