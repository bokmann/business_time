module BusinessTime
  class ParsedTime
    include Comparable

    attr_reader :hour, :min, :sec

    def initialize(hour, min = 0, sec = 0)
      @hour = hour
      @min = min
      @sec = sec
    end

    def self.parse(time_or_string)
      if time_or_string.is_a?(String)
        time = Time.parse(time_or_string)
      else
        time = time_or_string
      end
      new(time.hour, time.min, time.sec)
    end

    def to_s
      "#{hour}:#{min}:#{sec}"
    end

    def -(other)
      (hour - other.hour) * 3600 + (min - other.min) * 60 + sec - other.sec
    end

    def <=>(other)
      [hour, min, sec] <=> [other.hour, other.min, other.sec]
    end
  end
end
