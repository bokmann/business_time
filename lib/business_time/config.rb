module BusinessTime
  
  # controls the behavior of the code.  You can change
  # the beginning_of_workday, end_of_workday, and the list of holidays
  class Config
    class << self
      attr_accessor :beginning_of_workday
      attr_accessor :end_of_workday
      attr_accessor :holidays
  
    end
    self.holidays = []
    self.beginning_of_workday = "9:00 am"
    self.end_of_workday = "5:00 pm"
  end
  
end
