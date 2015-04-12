class ActiveSupport::TimeWithZone
  include BusinessTime::TimeExtensions
  extend BusinessTime::TimeExtensions::ClassMethods
end
