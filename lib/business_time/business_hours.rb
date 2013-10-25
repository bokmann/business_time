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

      number_of_weeks = @hours / BusinessTime::Config.business_hours_in_a_week
      remaining_hours = ((number_of_weeks % 1) * BusinessTime::Config.business_hours_in_a_week).round
      business_weeks = number_of_weeks.floor

      after_time = (business_weeks * BusinessTime::Config.business_days_in_a_week).business_days.after(after_time)
      after_time = BusinessHours.travel_business_hours_in_future(after_time, remaining_hours)

      after_time
    end
    alias_method :since, :after

    def before(time)
      before_time = Time.roll_forward(time)
      # Step through the hours, skipping over non-business hours
      @hours.times do
        before_time = before_time - 1.hour

        # Ignore hours before opening and after closing
        if (before_time < Time.beginning_of_workday(before_time))
          before_time = before_time - self.class.off_hours
        end

        # Ignore weekends and holidays
        while !Time.workday?(before_time)
          before_time = before_time - 1.day
        end
      end
      before_time
    end

    def self.travel_business_hours_in_future(time, hours)
      after_time = time

      # Step through the hours, skipping over non-business hours
      hours.times do
        after_time = after_time + 1.hour

        # Ignore hours before opening and after closing
        if (after_time > Time.end_of_workday(after_time))
          after_time = after_time + off_hours
        end

        # Ignore weekends
        while !Time.workday?(after_time)
          after_time = after_time + 1.day
        end
      end
      after_time
    end

    def self.off_hours
      return @gap if @gap
      if Time.zone
        gap_end = Time.zone.parse(BusinessTime::Config.beginning_of_workday)
        gap_begin = (Time.zone.parse(BusinessTime::Config.end_of_workday)-1.day)
      else
        gap_end = Time.parse(BusinessTime::Config.beginning_of_workday)
        gap_begin = (Time.parse(BusinessTime::Config.end_of_workday) - 1.day)
      end
      @gap = gap_end - gap_begin
    end
  end

end
