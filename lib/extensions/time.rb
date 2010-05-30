# Add workday and weekday concepts to the Time class
class Time
  class << self

    # Gives the time at the end of the workday, assuming that this time falls on a
    # workday.
    # Note: It pretends that this day is a workday whether or not it really is a
    # workday.
    def end_of_workday(day)
      format = "%B %d %Y #{BusinessTime::Config.end_of_workday}"
      Time.zone ? Time.zone.parse(day.strftime(format)) :
          Time.parse(day.strftime(format))
    end

    # Gives the time at the beginning of the workday, assuming that this time
    # falls on a workday.
    # Note: It pretends that this day is a workday whether or not it really is a
    # workday.
    def beginning_of_workday(day)
      format = "%B %d %Y #{BusinessTime::Config.beginning_of_workday}"
      Time.zone ? Time.zone.parse(day.strftime(format)) :
          Time.parse(day.strftime(format))
    end

    # True if this time is on a workday (between 00:00:00 and 23:59:59), even if
    # this time falls outside of normal business hours.
    def workday?(day)
      Time.weekday?(day) &&
          !BusinessTime::Config.holidays.include?(day.to_date)
    end

    # True if this time falls on a weekday.
    def weekday?(day)
      # TODO AS: Internationalize this!
      [1,2,3,4,5].include? day.wday
    end

    def before_business_hours?(time)
      time < beginning_of_workday(time)
    end

    def after_business_hours?(time)
      time > end_of_workday(time)
    end

    # Rolls forward to the next beginning_of_workday
    # when the time is outside of business hours
    def roll_forward(time)

      if (Time.before_business_hours?(time) || !Time.workday?(time))
        next_business_time = Time.beginning_of_workday(time)
      elsif Time.after_business_hours?(time)
        next_business_time = Time.beginning_of_workday(time) + 1.day
      else
        next_business_time = time.clone
      end

      while !Time.workday?(next_business_time)
        next_business_time += 1.day
      end

      next_business_time
    end

  end
end
