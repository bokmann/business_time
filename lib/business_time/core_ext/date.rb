# Add workday and weekday concepts to the Date class
class Date
  include BusinessTime::TimeExtensions

  def business_days_until(to_date, inclusive = false, with_holidays: true)
    business_dates_until(to_date, inclusive, with_holidays: with_holidays).size
  end

  def business_dates_until(to_date, inclusive = false, with_holidays: true)
    if inclusive
      (self..to_date).select { |date| date.workday?(with_holidays: with_holidays) }
    else
      (self...to_date).select { |date| date.workday?(with_holidays: with_holidays) }
    end
  end
end
