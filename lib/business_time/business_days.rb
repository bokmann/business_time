require 'active_support/time'

module BusinessTime
  class BusinessDays
    def initialize(days)
      @days = days
    end

    def after(time = Time.now)
      time = Time.zone ? Time.zone.parse(time.strftime('%Y-%m-%d %H:%M:%S %z')) : Time.parse(time.strftime('%Y-%m-%d %H:%M:%S %z'))
      days = @days
      while days > 0 || !time.workday?
        days -= 1 if time.workday?
        time = time + 1.day
      end
      time
    end

    alias_method :from_now, :after
    alias_method :since, :after

    def before(time = Time.now)
      time = Time.zone ? Time.zone.parse(time.rfc822) : Time.parse(time.rfc822)
      days = @days
      while days > 0 || !time.workday?
        days -= 1 if time.workday?
        time = time - 1.day
      end
      time
    end

    alias_method :ago, :before
    alias_method :until, :before
  end
end
