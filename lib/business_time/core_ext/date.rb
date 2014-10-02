# Add workday and weekday concepts to the Date class
class Date
  include BusinessTime::TimeExtensions

  def business_days_until(to_date)
    (self...to_date).select{ |day| day.workday? }.size
  end
end
