require 'active_support/core_ext'

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
      #   BusinessTime::Config.work_week = [:sun, :mon, :tue, :wed, :thu]
      # someplace in the initializers of your application.
      attr_accessor :work_week

      # You can set this yourself, either by the load method below, or
      # by saying
      #   BusinessTime::Config.holidays << my_holiday_date_object
      # someplace in the initializers of your application.
      attr_accessor :holidays

    end

    def self.work_week=(days)
      @work_week = days
      @weekdays = nil
    end

    def self.weekdays
      return @weekdays unless @weekdays.nil?

      lowercase_day_names = ::Time::RFC2822_DAY_NAME.map(&:downcase)

      @weekdays = work_week.each_with_object([]) do |day_name, days|
        day_num = lowercase_day_names.find_index(day_name.to_s.downcase)
        days << day_num unless day_num.nil?
      end
    end

    def self.reset
      self.holidays = []
      self.beginning_of_workday = "9:00 am"
      self.end_of_workday = "5:00 pm"
      self.work_week = %w[mon tue wed thu fri]
      @weekdays = nil
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
    def self.load(file)
      self.reset
      data = YAML::load(file.respond_to?(:read) ? file : File.open(file))
      config = (data["business_time"] || {})
      self.beginning_of_workday = config["beginning_of_workday"] if config["beginning_of_workday"]
      self.end_of_workday = config["end_of_workday"] if config["end_of_workday"]
      self.work_week = config["work_week"] if config["work_week"]
      (config["holidays"] || []).each do |holiday|
        self.holidays << (Time.zone ? Time.zone.parse(holiday) : Time.parse(holiday))
      end

    end

    #reset the first time we are loaded.
    self.reset
  end

end
