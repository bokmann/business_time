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
        raise ArgumentError.new("#{self.class} can't be compared with #{other.class}")
      end
      self.days <=> other.days
    end

    def after(time = Time.current, count_from_dayoff: false)
      if non_negative_days?
        calculate_after(time, @days, count_from_dayoff: count_from_dayoff)
      else
        calculate_before(time, -@days, count_from_dayoff: count_from_dayoff)
      end
    end

    alias_method :from_now, :after
    alias_method :since, :after

    def before(time = Time.current, count_from_dayoff: false)
      if non_negative_days?
        calculate_before(time, @days, count_from_dayoff: count_from_dayoff)
      else
        calculate_after(time, -@days, count_from_dayoff: count_from_dayoff)
      end
    end

    alias_method :ago, :before
    alias_method :until, :before

    private

    def non_negative_days?
      @days >= 0
    end

    def calculate_after(time, days, count_from_dayoff: )
      i = 0
      while days > 0 || !time.workday?
        days -= 1 if time.workday? || (count_from_dayoff && i == 0)
        time += 1.day
        i += 1
      end
      # If we have a Time or DateTime object, we can roll_forward to the
      #   beginning of the next business day
      if time.is_a?(Time) || time.is_a?(DateTime)
        time = Time.roll_forward(time) unless time.during_business_hours?
      end
      time
    end

    def calculate_before(time, days, count_from_dayoff: )
      i = 0
      while days > 0 || !time.workday?
        days -= 1 if time.workday? || (count_from_dayoff && i == 0)
        time -= 1.day
        i += 1
      end
      # If we have a Time or DateTime object, we can roll_backward to the
      #   beginning of the previous business day
      if time.is_a?(Time) || time.is_a?(DateTime)
        unless time.during_business_hours?
          time = Time.beginning_of_workday(Time.roll_backward(time))
        end
      end
      time
    end
  end
end
