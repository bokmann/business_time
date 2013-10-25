require 'active_support/time'

module BusinessTime

  class BusinessDays
    def initialize(days)
      @days = days
    end

    def after(time = Time.now)
      time = Time.zone ? Time.zone.parse(time.to_s) : Time.parse(time.to_s)
      start_time = time
      days = @days

      number_of_weeks = days / BusinessTime::Config.business_days_in_a_week.to_f
      remaining_days = ((number_of_weeks % 1) * BusinessTime::Config.business_days_in_a_week).round
      business_weeks = number_of_weeks.floor

      time += business_weeks.weeks

      start_time_holidays = start_time - 1.day
      begin
        holidays_count = BusinessTime::Config.holidays_count_between((start_time_holidays + 1.day).to_date, time.to_date)
        start_time_holidays = time
        time += holidays_count.days
      end while holidays_count > 0 # If we encounter an holiday, verify if the days we added are also holidays

      time = BusinessDays.travel_business_days_in_future(time, remaining_days)

      time
    end

    alias_method :from_now, :after
    alias_method :since, :after

    def before(time = Time.now)
      time = Time.zone ? Time.zone.parse(time.to_s) : Time.parse(time.to_s)
      days = @days
      while days > 0 || !Time.workday?(time)
        days -= 1 if Time.workday?(time)
        time = time - 1.day
      end
      time
    end

    alias_method :ago, :before
    alias_method :until, :before

    def self.travel_business_days_in_future(time, days)
      while days > 0 || !Time.workday?(time)
        days -= 1 if Time.workday?(time)
        time = time + 1.day
      end

      time
    end
  end

end
