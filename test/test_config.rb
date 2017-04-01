require File.expand_path('../helper', __FILE__)

describe "config" do
  it "keep track of the start of the day" do
    assert_equal BusinessTime::ParsedTime.new(9, 0), BusinessTime::Config.beginning_of_workday
    BusinessTime::Config.beginning_of_workday = "8:30 am"
    assert_equal BusinessTime::ParsedTime.new(8, 30), BusinessTime::Config.beginning_of_workday
  end

  it "keep track of the end of the day" do
    assert_equal BusinessTime::ParsedTime.new(17, 0), BusinessTime::Config.end_of_workday
    BusinessTime::Config.end_of_workday = "5:30 pm"
    assert_equal BusinessTime::ParsedTime.new(17, 30), BusinessTime::Config.end_of_workday
  end

  it "keep track of holidays" do
    assert BusinessTime::Config.holidays.empty?
    daves_birthday = Date.parse("August 4th, 1969")
    BusinessTime::Config.holidays << daves_birthday
    assert BusinessTime::Config.holidays.include?(daves_birthday)
  end

  it "keep track of work week" do
    assert_equal %w[mon tue wed thu fri], BusinessTime::Config.work_week
    BusinessTime::Config.work_week = %w[sun mon tue wed thu]
    assert_equal %w[sun mon tue wed thu], BusinessTime::Config.work_week
  end

  it "map work week to weekdays" do
    assert_equal SortedSet.new([1,2,3,4,5]), BusinessTime::Config.weekdays
    BusinessTime::Config.work_week = %w[sun mon tue wed thu]
    assert_equal SortedSet.new([0,1,2,3,4]), BusinessTime::Config.weekdays
    BusinessTime::Config.work_week = %w[tue wed] # Hey, we got it made!
    assert_equal SortedSet.new([2,3]), BusinessTime::Config.weekdays
  end

  it "keep track of the start of the day using work_hours" do
    assert_equal({},BusinessTime::Config.work_hours)
    BusinessTime::Config.work_hours = {
      :mon=>["9:00","17:00"],
      :tue=>["9:00","17:00"],
      :thu=>["9:00","17:00"],
      :fri=>["9:00","17:00"]
    }
    assert_equal({
      mon: [BusinessTime::ParsedTime.new(9),BusinessTime::ParsedTime.new(17)],
      tue: [BusinessTime::ParsedTime.new(9),BusinessTime::ParsedTime.new(17)],
      thu: [BusinessTime::ParsedTime.new(9),BusinessTime::ParsedTime.new(17)],
      fri: [BusinessTime::ParsedTime.new(9),BusinessTime::ParsedTime.new(17)]
    }, BusinessTime::Config.work_hours)
    assert_equal([1,2,4,5], BusinessTime::Config.weekdays.sort)
  end

  it 'end of workday not freakout' do
    BusinessTime::Config.work_hours = {
      :mon=>["9:00","20:00"],
      :tue=>["9:00","17:00"],
      :thu=>["9:00","17:00"],
      :fri=>["9:00","17:00"]
    }

    monday = Time.local(2014, 05, 12, 20, 50)
    assert_equal BusinessTime::ParsedTime.new(20, 0), BusinessTime::Config.end_of_workday(monday)
  end

  it "load config from YAML files" do
    yaml = <<-YAML
    business_time:
      beginning_of_workday: 11:00 am
      end_of_workday: 2:00 pm
      work_week:
        - mon
      holidays:
        - December 25th, 2012
    YAML
    config_file = StringIO.new(yaml.gsub!(/^    /, ''))
    BusinessTime::Config.load(config_file)
    assert_equal BusinessTime::ParsedTime.new(11, 0), BusinessTime::Config.beginning_of_workday
    assert_equal BusinessTime::ParsedTime.new(14, 0), BusinessTime::Config.end_of_workday
    assert_equal ['mon'], BusinessTime::Config.work_week
    assert_equal SortedSet.new([Date.parse('2012-12-25')]), BusinessTime::Config.holidays
  end

  it "include holidays read from YAML config files" do
    yaml = <<-YAML
    business_time:
      holidays:
        - May 7th, 2012
    YAML
    assert Time.parse('2012-05-07').workday?
    config_file = StringIO.new(yaml.gsub!(/^    /, ''))
    BusinessTime::Config.load(config_file)
    assert !Time.parse('2012-05-07').workday?
  end

  it "use defaults for values missing in YAML file" do
    yaml = <<-YAML
    business_time:
      missing_values: yup
    YAML
    config_file = StringIO.new(yaml.gsub!(/^    /, ''))
    BusinessTime::Config.load(config_file)
    assert_equal BusinessTime::ParsedTime.new(9, 0), BusinessTime::Config.beginning_of_workday
    assert_equal BusinessTime::ParsedTime.new(17, 0), BusinessTime::Config.end_of_workday
    assert_equal %w[mon tue wed thu fri], BusinessTime::Config.work_week
    assert_equal SortedSet.new, BusinessTime::Config.holidays
  end

  it "is threadsafe" do
    BusinessTime::Config.end_of_workday = "3pm"
    t = Thread.new do
      BusinessTime::Config.end_of_workday = "4pm"
      assert_equal BusinessTime::ParsedTime.new(16, 0), BusinessTime::Config.end_of_workday
    end
    assert_equal BusinessTime::ParsedTime.new(15, 0), BusinessTime::Config.end_of_workday
    t.join
  end

  describe "#with" do
    it "changes config" do
      ran = false
      BusinessTime::Config.with(:end_of_workday => "2pm") do
        assert_equal BusinessTime::ParsedTime.new(14, 0), BusinessTime::Config.end_of_workday
        ran = true
      end
      assert ran
    end

    it "inherits" do
      ran = false
      BusinessTime::Config.with(:end_of_workday => "2pm") do
        BusinessTime::Config.with(:beginning_of_workday => "1pm") do
          assert_equal BusinessTime::ParsedTime.new(13, 0), BusinessTime::Config.beginning_of_workday
          assert_equal BusinessTime::ParsedTime.new(14, 0), BusinessTime::Config.end_of_workday
          ran = true
        end
      end
      assert ran
    end

    it "resets config after the block" do
      ran = false
      BusinessTime::Config.with(:end_of_workday => "2pm") { ran = true }
      assert ran
      assert_equal BusinessTime::ParsedTime.new(17, 0), BusinessTime::Config.end_of_workday
    end

    it "resets config after error" do
      ran = false
      assert_raises RuntimeError do
        BusinessTime::Config.with(:end_of_workday => "2pm") { ran = true; raise }
      end
      assert ran
      assert_equal BusinessTime::ParsedTime.new(17, 0), BusinessTime::Config.end_of_workday
    end

    it 'is threadsafe' do
      old_hours = { fri: [BusinessTime::ParsedTime.new(10), BusinessTime::ParsedTime.new(12)] }
      new_hours = { fri: [BusinessTime::ParsedTime.new(10), BusinessTime::ParsedTime.new(13)] }
      BusinessTime::Config.work_hours = old_hours
      t1 = Thread.new do
        sleep 0.1
        assert_equal BusinessTime::Config.work_hours, old_hours
      end
      Thread.new do
        BusinessTime::Config.with(work_hours: new_hours) do
          t1.join
          assert_equal BusinessTime::Config.work_hours, new_hours
        end
      end.join
    end
  end
end
