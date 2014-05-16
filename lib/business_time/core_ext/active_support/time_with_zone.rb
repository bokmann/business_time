class ActiveSupport::TimeWithZone
  include BusinessTime::TimeExtensions

  def business_time_until(to_time)
    to_time = to_time.time if to_time.respond_to? :time
    self.time.business_time_until(to_time)
  end
end
