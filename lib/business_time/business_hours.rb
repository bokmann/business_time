module BusinessTime

  class BusinessHours
    def initialize(hours)
      @hours = hours
    end

    def ago
      Time.zone ? before(Time.zone.now) : before(Time.now)
    end

    def from_now
      Time.zone ?  after(Time.zone.now) : after(Time.now)
    end

    def after(time)
      after_time = Time.roll_forward(time)
      # Step through the hours, skipping over non-business hours
      @hours.times do
        after_time = after_time + 1.hour

        if after_time.hour == 0 && after_time.min == 0 && after_time.sec == 0
          after_time = Time.roll_forward(after_time)
        elsif (after_time > Time.end_of_workday(after_time))
          # Ignore hours before opening and after closing
          delta = after_time - Time.end_of_workday(after_time)
          after_time = Time.roll_forward(after_time) + delta
        end

        # Ignore weekends and holidays
        while !after_time.workday?
          after_time = after_time + 1.day
        end
      end
      after_time
    end
    alias_method :since, :after

    def before(time)
      before_time = Time.roll_backward(time)
      # Step through the hours, skipping over non-business hours
      @hours.times do
        before_time = before_time - 1.hour

        if before_time.hour == 0 && before_time.min == 0 && before_time.sec == 0
          before_time = Time.roll_backward(before_time - 1.second)
        elsif (before_time <= Time.beginning_of_workday(before_time))
          # Ignore hours before opening and after closing
          delta = Time.beginning_of_workday(before_time) - before_time

          # Due to the 23:59:59 end-of-workday exception
          time_roll_backward = Time.roll_backward(before_time)
          time_roll_backward += 1.second if time_roll_backward.to_s =~ /23:59:59/

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
