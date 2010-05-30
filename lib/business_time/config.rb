module BusinessTime
  
  # controls the behavior of this gem.  You can change
  # the beginning_of_workday, end_of_workday, and the list of holidays
  # manually, or with a yaml file and the load method.
  class Config
    class << self
      # You can set this yourself, either by the load method below, or
      # by saying
      #   BusinessTime::Config.beginning_of_workday = "8:30 am"
      # someplace in the initializers of your application.
      attr_accessor :beginning_of_workday
      
      # You can set this yourself, either by the load method below, or
      # by saying
      #   BusinessTime::Config.end_of_workday = "5:30 pm"
      # someplace in the initializers of your application.
      attr_accessor :end_of_workday
      
      # You can set this yourself, either by the load method below, or
      # by saying
      #   BusinessTime::Config.holidays << my_holiday_date_object
      # someplace in the initializers of your application.
      attr_accessor :holidays

    end
    
    def self.reset
      self.holidays = []
      self.beginning_of_workday = "9:00 am"
      self.end_of_workday = "5:00 pm"
    end
    
    # loads the config data from a yaml file written as:
    #
    #   business_time:
    #     beginning_od_workday: 8:30 am
    #     end_of_workday: 5:30 pm
    #     holidays:
    #       - Jan 1st, 2010
    #       - July 4th, 2010
    #       - Dec 25th, 2010
    def self.load(filename)
      self.reset
      data = YAML::load(File.open(filename))
      self.beginning_of_workday = data["business_time"]["beginning_of_workday"]
      self.end_of_workday = data["business_time"]["end_of_workday"]
      data["business_time"]["holidays"].each do |holiday|
        self.holidays <<
          Time.zone ? Time.zone.parse(holiday) : Time.parse(holiday)
      end
      
    end
    
    #reset the first time we are loaded.
    self.reset
  end
  
end
