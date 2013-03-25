# hook into fixnum so we can say things like:
#  5.business_hours.from_now
#  7.business_days.ago
#  3.business_days.after(some_date)
#  4.business_hours.before(some_date_time)
#  5.business_minutes.from_now
#  4.business_minutes.before(some_date_time)
class Fixnum
  include BusinessTime

  def business_minutes
    BusinessMinutes.new(self)
  end
  alias_method :business_minute, :business_minutes

  def business_hours
    BusinessHours.new(self)
  end
  alias_method :business_hour, :business_hours

  def business_days
    BusinessDays.new(self)
  end
  alias_method :business_day, :business_days
end
