module BusinessTime

  class BusinessHours
    include Comparable
    attr_reader :hours

    def initialize(hours, options={})
      @hours = hours
    end

    def <=>(other)
      if other.class != self.class
        raise ArgumentError.new("#{self.class.to_s} can't be compared with #{other.class.to_s}")
      end
      self.hours <=> other.hours
    end
    
    def ago(options={})
      Time.zone ? before(Time.zone.now, options) : before(Time.now, options)
    end

    def from_now(options={})
      Time.zone ?  after(Time.zone.now, options) : after(Time.now, options)
    end

    def after(time, options={})
      non_negative_hours? ? calculate_after(time, @hours, options) : calculate_before(time, -@hours, options)
    end
    alias_method :since, :after

    def before(time, options={})
      non_negative_hours? ? calculate_before(time, @hours, options) : calculate_after(time, -@hours, options)
    end

    private

    def non_negative_hours?
      @hours >= 0
    end

    def calculate_after(time, hours, options={})
      after_time = Time.roll_forward(time, options)
      # Step through the hours, skipping over non-business hours
      hours.times do
        eod = Time.end_of_workday(after_time)
        after_time = after_time + 1.hour

        # Ignore hours before opening and after closing
        if after_time > eod
          delta = after_time - eod

          # Handle errors due to XX:59:59 exceptions
          delta = 0 if delta == 1.second

          after_time = Time.roll_forward(after_time, options) + delta
        end

        # Ignore weekends and holidays
        while !after_time.workday?
          after_time = after_time + 1.day
        end
      end
      after_time
    end

    def calculate_before(time, hours, options={})
      before_time = Time.roll_backward(time)
      # Step through the hours, skipping over non-business hours
      hours.times do
        bod = Time.beginning_of_workday(before_time)
        before_time = before_time - 1.hour

        # Ignore hours before opening and after closing
        if before_time <= bod
          delta = bod - before_time

          # Due to the 23:59:59 end-of-workday exception
          time_roll_backward = Time.roll_backward(before_time, options)
          time_roll_backward += 1.second if time_roll_backward.iso8601 =~ /23:59:59/

          before_time = time_roll_backward - delta
        end

        # Ignore weekends and holidays
        while !before_time.workday?
          before_time = before_time - 1.day
        end
      end
      before_time
    end
  end
end
