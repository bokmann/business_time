# Add workday and weekday concepts to the Time class
class Time
  include BusinessTime::TimeExtensions
  extend BusinessTime::TimeExtensions::ClassMethods
end
