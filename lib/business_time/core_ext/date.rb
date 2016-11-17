# Add workday and weekday concepts to the Date class
class Date
  include BusinessTime::TimeExtensions

  def business_days_until(to_date, inclusive = false)
    business_dates_until(to_date, inclusive).size
  end

  def business_dates_until(to_date, inclusive = false)
    if inclusive
      (self..to_date).select(&:workday?)
    else
      (self...to_date).select(&:workday?)
    end
  end

  # Adapted from:
  # https://github.com/activewarehouse/activewarehouse/blob/master/lib/active_warehouse/core_ext/time/calculations.rb

  def week
    cyw = ((yday - 1) / 7) + 1
    cyw = 52 if cyw == 53
    cyw
  end

  def quarter
    ((month - 1) / 3) + 1
  end

  def fiscal_month_offset
    BusinessTime::Config.fiscal_month_offset
  end

  def fiscal_year_week
    fyw = ((fiscal_year_yday - 1) / 7) + 1
    fyw = 52 if fyw == 53
    fyw
  end

  def fiscal_year_month
    shifted_month = month - (fiscal_month_offset - 1)
    shifted_month += 12 if shifted_month <= 0
    shifted_month
  end

  def fiscal_year_quarter
    ((fiscal_year_month - 1) / 3) + 1
  end

  def fiscal_year
    month >= fiscal_month_offset ? year + 1 : year
  end

  def fiscal_year_yday
    offset_days = 0
    1.upto(fiscal_month_offset - 1) { |m| offset_days += ::Time.days_in_month(m, year) }
    shifted_year_day = yday - offset_days
    shifted_year_day += 365 if shifted_year_day <= 0
    shifted_year_day
  end
end
