# Add workday and weekday concepts to the Date class
class Date
  include BusinessTime::TimeExtensions

  def business_days_until(to_date)
    business_dates_until(to_date).size
  end

  def business_dates_until(to_date)
    (self...to_date).select { |day| day.workday? }
  end
end