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
      after_time = Time.roll_forward(time)
      # Step through the hours, skipping over non-business hours
      @hours.times do
        after_time = after_time + 1.hour

        # Ignore hours before opening and after closing
        if (after_time > Time.end_of_workday(after_time))
          after_time = after_time + off_hours
        end

        # Ignore weekends and holidays
        while !Time.workday?(after_time)
          after_time = after_time + 1.day
        end
      end
      after_time
    end

    def before(time)
      before_time = Time.roll_forward(time)
      # Step through the hours, skipping over non-business hours
      @hours.times do
        before_time = before_time - 1.hour

        # Ignore hours before opening and after closing
        if (before_time < Time.beginning_of_workday(before_time))
          before_time = before_time - off_hours
        end

        # Ignore weekends and holidays
        while !Time.workday?(before_time)
          before_time = before_time - 1.day
        end
      end
      before_time
    end

    private

    def off_hours
      @gap ||= Time.parse(BusinessTime::Config.beginning_of_workday) -
              (Time.parse(BusinessTime::Config.end_of_workday) - 1.day)
    end
  end

end
