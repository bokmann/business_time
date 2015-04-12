module BusinessTime
  module TimeExtensions
    # True if this time is on a workday (between 00:00:00 and 23:59:59), even if
    # this time falls outside of normal business hours.
    def workday?
      weekday? && !BusinessTime::Config.holidays.include?(to_date)
    end

    # True if this time falls on a weekday.
    def weekday?
      BusinessTime::Config.weekdays.include?(wday)
    end

    module ClassMethods
      # Gives the time at the end of the workday, assuming that this time falls on a
      # workday.
      # Note: It pretends that this day is a workday whether or not it really is a
      # workday.
      def end_of_workday(day)
        end_of_workday = Time.parse(BusinessTime::Config.end_of_workday(day))
        change_business_time(day,end_of_workday.hour,end_of_workday.min,end_of_workday.sec)
      end

      # Gives the time at the beginning of the workday, assuming that this time
      # falls on a workday.
      # Note: It pretends that this day is a workday whether or not it really is a
      # workday.
      def beginning_of_workday(day)
        beginning_of_workday = Time.parse(BusinessTime::Config.beginning_of_workday(day))
        change_business_time(day,beginning_of_workday.hour,beginning_of_workday.min,beginning_of_workday.sec)
      end

      # True if this time is on a workday (between 00:00:00 and 23:59:59), even if
      # this time falls outside of normal business hours.
      def workday?(day)
        ActiveSupport::Deprecation.warn("`Time.workday?(time)` is deprecated. Please use `time.workday?`")
        day.workday?
      end

      # True if this time falls on a weekday.
      def weekday?(day)
        ActiveSupport::Deprecation.warn("`Time.weekday?(time)` is deprecated. Please use `time.weekday?`")
        day.weekday?
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

        if Time.before_business_hours?(time) || !time.workday?
          next_business_time = Time.beginning_of_workday(time)
        elsif Time.after_business_hours?(time) || Time.end_of_workday(time) == time
          next_business_time = Time.beginning_of_workday(time + 1.day)
        else
          next_business_time = time.clone
        end

        while !next_business_time.workday?
          next_business_time = Time.beginning_of_workday(next_business_time + 1.day)
        end

        next_business_time
      end

      # Returns the time parameter itself if it is a business day
      # or else returns the next business day
      def first_business_day(time)
        while !time.workday?
          time = time + 1.day
        end

        time
      end

      # Rolls backwards to the previous end_of_workday when the time is outside
      # of business hours
      def roll_backward(time)
        prev_business_time = if (Time.before_business_hours?(time) || !time.workday?)
                               Time.end_of_workday(time - 1.day)
                             elsif Time.after_business_hours?(time)
                               Time.end_of_workday(time)
                             else
                               time.clone
                             end

        while !prev_business_time.workday?
          prev_business_time = Time.end_of_workday(prev_business_time - 1.day)
        end

        prev_business_time
      end

      def work_hours_total(day)
        return 0 unless day.workday?

        day = day.strftime('%a').downcase.to_sym

        if hours = BusinessTime::Config.work_hours[day]
          BusinessTime::Config.work_hours_total[day] ||= begin
            hours_last = hours.last
            if hours_last == '00:00'
              (Time.parse('23:59') - Time.parse(hours.first)) + 1.minute
            else
              Time.parse(hours_last) - Time.parse(hours.first)
            end
          end
        else
          BusinessTime::Config.work_hours_total[:default] ||= begin
            Time.parse(BusinessTime::Config.end_of_workday) - Time.parse(BusinessTime::Config.beginning_of_workday)
          end
        end
      end

      private

      def change_business_time time, hour, min=0, sec=0
        if Time.zone
          time.in_time_zone(Time.zone).change(:hour => hour, :min => min, :sec => sec)
        else
          time.change(:hour => hour, :min => min, :sec => sec)
        end
      end
    end

    def business_time_until(to_time)
      # Make sure that we will calculate time from A to B "clockwise"
      if self < to_time
        time_a = self
        time_b = to_time
        direction = 1
      else
        time_a = to_time
        time_b = self
        direction = -1
      end

      # Align both times to the closest business hours
      time_a = Time::roll_forward(time_a)
      time_b = Time::roll_forward(time_b)

      if time_a.to_date == time_b.to_date
        time_b - time_a
      else
        end_of_workday = Time.end_of_workday(time_a)
        end_of_workday += 1 if end_of_workday.to_s =~ /23:59:59/

        first_day       = end_of_workday - time_a
        days_in_between = ((time_a.to_date + 1)..(time_b.to_date - 1)).sum{ |day| Time::work_hours_total(day) }
        last_day        = time_b - Time.beginning_of_workday(time_b)

        first_day + days_in_between + last_day
      end * direction
    end
    
    def during_business_hours?
      self.workday? && self.to_i.between?(Time.beginning_of_workday(self).to_i, Time.end_of_workday(self).to_i)
    end
  end
end
