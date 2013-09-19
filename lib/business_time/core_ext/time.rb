# Add workday and weekday concepts to the Time class
class Time
  class << self

    # Gives the time at the end of the workday, assuming that this time falls on a
    # workday.
    # Note: It pretends that this day is a workday whether or not it really is a
    # workday.
    def end_of_workday(day)
      end_of_workday = Time.parse(BusinessTime::Config.end_of_workday(day))
      change_time(day,end_of_workday.hour,end_of_workday.min,end_of_workday.sec)
    end

    # Gives the time at the beginning of the workday, assuming that this time
    # falls on a workday.
    # Note: It pretends that this day is a workday whether or not it really is a
    # workday.
    def beginning_of_workday(day)
      beginning_of_workday = Time.parse(BusinessTime::Config.beginning_of_workday(day))
      change_time(day,beginning_of_workday.hour,beginning_of_workday.min,beginning_of_workday.sec)
    end

    # True if this time is on a workday (between 00:00:00 and 23:59:59), even if
    # this time falls outside of normal business hours.
    def workday?(day)
      Time.weekday?(day) &&
          !BusinessTime::Config.holidays.include?(day.to_date)
    end

    # True if this time falls on a weekday.
    def weekday?(day)
      BusinessTime::Config.weekdays.include? day.wday
    end

    def before_business_hours?(time)
      time.to_i < beginning_of_workday(time).to_i
    end

    def after_business_hours?(time)
      time.to_i > end_of_workday(time).to_i
    end

    # Rolls forward to the next beginning_of_workday
    # when the time is outside of business hours
    def roll_forward(time)

      if (Time.before_business_hours?(time) || !Time.workday?(time))
        next_business_time = Time.beginning_of_workday(time)
      elsif Time.after_business_hours?(time) || Time.end_of_workday(time) == time
        next_business_time = Time.beginning_of_workday(time + 1.day)
      else
        next_business_time = time.clone
      end

      while !Time.workday?(next_business_time)
        next_business_time = Time.beginning_of_workday(next_business_time + 1.day)
      end

      next_business_time
    end

    # Rolls backwards to the previous end_of_workday when the time is outside
    # of business hours
    def roll_backward(time)
      if (Time.before_business_hours?(time) || !Time.workday?(time))
        prev_business_time = Time.end_of_workday(time) - 1.day
      elsif Time.after_business_hours?(time)
        prev_business_time = Time.end_of_workday(time)
      else
        prev_business_time = time.clone
      end

      while !Time.workday?(prev_business_time)
        prev_business_time -= 1.day
      end

      prev_business_time
    end

    private

    def change_time time, hour, min=0, sec=0
      if Time.zone
        time.in_time_zone(Time.zone).change(:hour => hour, :min => min, :sec => sec)
      else
        time.change(:hour => hour, :min => min, :sec => sec)
      end
    end


  end
end

class Time

  def business_time_until(to_time=nil)

    to_time = Time.parse(self.strftime('%Y-%m-%d ') + BusinessTime::Config.end_of_workday) if to_time.nil?

    # Make sure that we will calculate time from A to B "clockwise"
    direction = 1
    if self < to_time
      time_a = self
      time_b = to_time
    else
      time_a = to_time
      time_b = self
      direction = -1
    end

    # Align both times to the closest business hours
    time_a = Time::roll_forward(time_a)
    time_b = Time::roll_forward(time_b)

    # If same date, then calculate difference straight forward
    if time_a.to_date == time_b.to_date
      result = time_b - time_a
      return result *= direction
    end

    # Both times are in different dates
    #result = Time.parse(time_a.strftime('%Y-%m-%d ') + BusinessTime::Config.end_of_workday) - time_a   # First day
    #result += time_b - Time.parse(time_b.strftime('%Y-%m-%d ') + BusinessTime::Config.beginning_of_workday) # Last day

    result = 0

    # All days in between
    time_c = time_a
    while time_c.to_i < time_b.to_i do
      end_of_workday = Time.end_of_workday(time_c)
      if time_c.to_date == time_b.to_date
        if end_of_workday < time_b
          result += end_of_workday - time_c
          break
        else
          result += time_b - time_c
          break
        end
      else
        result += end_of_workday - time_c
        time_c = Time::roll_forward(end_of_workday)
      end
      result += 1 if end_of_workday.to_s =~ /23:59:59/
    end

    # Make sure that sign is correct
    result *= direction
  end

end
