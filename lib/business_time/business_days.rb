require 'active_support/time'

module BusinessTime
  class BusinessDays
    include Comparable
    attr_reader :days

    def initialize(days, options={})
      @days = days
    end

    def <=>(other)
      if other.class != self.class
        raise ArgumentError.new("#{self.class} can't be compared with #{other.class}")
      end
      self.days <=> other.days
    end

    def after(time = Time.current, options={})
      non_negative_days? ? calculate_after(time, @days, options) : calculate_before(time, -@days, options)
    end

    alias_method :from_now, :after
    alias_method :since, :after

    def before(time = Time.current, options={})
      non_negative_days? ? calculate_before(time, @days, options) : calculate_after(time, -@days, options)
    end

    alias_method :ago, :before
    alias_method :until, :before

    private

    def non_negative_days?
      @days >= 0
    end

    def calculate_after(time, days, options={})
      if (time.is_a?(Time) || time.is_a?(DateTime)) && !time.workday?(options)
        time = Time.beginning_of_workday(time)
      end
      while days > 0 || !time.workday?(options)
        time += 1.day
        days -= 1 if time.workday?(options)
      end
      # If we have a Time or DateTime object, we can roll_forward to the
      #   beginning of the next business day
      if time.is_a?(Time) || time.is_a?(DateTime)
        time = Time.roll_forward(time, options) unless time.during_business_hours?
      end
      time
    end

    def calculate_before(time, days, options={})
      if (time.is_a?(Time) || time.is_a?(DateTime)) && !time.workday?(options)
        time = Time.beginning_of_workday(time)
      end
      while days > 0 || !time.workday?(options)
        time -= 1.day
        days -= 1 if time.workday?(options)
      end
      # If we have a Time or DateTime object, we can roll_backward to the
      #   beginning of the previous business day
      if time.is_a?(Time) || time.is_a?(DateTime)
        unless time.during_business_hours?
          time = Time.beginning_of_workday(Time.roll_backward(time, options))
        end
      end
      time
    end
  end
end
