require File.expand_path('../helper', __FILE__)

describe "config" do
  it "keep track of the start of the day" do
    assert_equal "9:00 am", BusinessTime::Config.beginning_of_workday
    BusinessTime::Config.beginning_of_workday = "8:30 am"
    assert_equal "8:30 am", BusinessTime::Config.beginning_of_workday
  end

  it "keep track of the end of the day" do
    assert_equal "5:00 pm", BusinessTime::Config.end_of_workday
    BusinessTime::Config.end_of_workday = "5:30 pm"
    assert_equal "5:30 pm", BusinessTime::Config.end_of_workday
  end

  it "keep track of holidays" do
    assert BusinessTime::Config.holidays.empty?
    daves_birthday = Date.parse("August 4th, 1969")
    BusinessTime::Config.add_holiday(daves_birthday)
    assert BusinessTime::Config.holidays.include?('04/08')
  end

  it "keep track of work week" do
    assert_equal %w[mon tue wed thu fri], BusinessTime::Config.work_week
    BusinessTime::Config.work_week = %w[sun mon tue wed thu]
    assert_equal %w[sun mon tue wed thu], BusinessTime::Config.work_week
  end

  it "map work week to weekdays" do
    assert_equal [1,2,3,4,5], BusinessTime::Config.weekdays
    BusinessTime::Config.work_week = %w[sun mon tue wed thu]
    assert_equal [0,1,2,3,4], BusinessTime::Config.weekdays
    BusinessTime::Config.work_week = %w[tue wed] # Hey, we got it made!
    assert_equal [2,3], BusinessTime::Config.weekdays
  end

  it "keep track of the start of the day using work_hours" do
    assert_equal({},BusinessTime::Config.work_hours)
    BusinessTime::Config.work_hours = {
      :mon=>["9:00","17:00"],
      :tue=>["9:00","17:00"],
      :thu=>["9:00","17:00"],
      :fri=>["9:00","17:00"]
    }
    assert_equal({:mon=>["9:00","17:00"],
      :tue=>["9:00","17:00"],
      :thu=>["9:00","17:00"],
      :fri=>["9:00","17:00"]
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
    assert_equal "20:00", BusinessTime::Config.end_of_workday(monday)
  end

  it "load config from YAML files" do
    Timecop.freeze('02/02/2011') do
      yaml = <<-YAML
      business_time:
        beginning_of_workday: 11:00 am
        end_of_workday: 2:00 pm
        work_week:
          - mon
        holidays:
          - December 25th
      YAML
      config_file = StringIO.new(yaml.gsub!(/^    /, ''))
      BusinessTime::Config.load(config_file)
      assert_equal "11:00 am", BusinessTime::Config.beginning_of_workday
      assert_equal "2:00 pm", BusinessTime::Config.end_of_workday
      assert_equal ['mon'], BusinessTime::Config.work_week
      assert_equal ['25/12'], BusinessTime::Config.holidays
    end
  end

  it "include holidays read from YAML config files" do
    Timecop.freeze('02/02/2011') do
      yaml = <<-YAML
      business_time:
        holidays:
          - May 10th
      YAML

      assert Time.parse('2011-05-10').workday?
      config_file = StringIO.new(yaml.gsub!(/^    /, ''))
      BusinessTime::Config.load(config_file)
      assert !Time.parse('2011-05-10').workday?
    end
  end

  it "ignore year when check date for holiday" do
    yaml = <<-YAML
      business_time:
        holidays:
          - May 10th
      YAML

    config_file = StringIO.new(yaml.gsub!(/^    /, ''))
    BusinessTime::Config.load(config_file)

    assert !Time.parse('2011-05-10').workday?
    assert !Time.parse('2012-05-10').workday?
  end

  it "use defaults for values missing in YAML file" do
    yaml = <<-YAML
    business_time:
      missing_values: yup
    YAML
    config_file = StringIO.new(yaml.gsub!(/^    /, ''))
    BusinessTime::Config.load(config_file)
    assert_equal "9:00 am", BusinessTime::Config.beginning_of_workday
    assert_equal "5:00 pm", BusinessTime::Config.end_of_workday
    assert_equal %w[mon tue wed thu fri], BusinessTime::Config.work_week
    assert_equal [], BusinessTime::Config.holidays
  end

  it "is threadsafe" do
    BusinessTime::Config.end_of_workday = "3pm"
    t = Thread.new do
      BusinessTime::Config.end_of_workday = "4pm"
      assert_equal "4pm", BusinessTime::Config.end_of_workday
    end
    assert_equal "3pm", BusinessTime::Config.end_of_workday
    t.join
  end

  describe "#with" do
    it "changes config" do
      ran = false
      BusinessTime::Config.with(:end_of_workday => "2pm") do
        assert_equal "2pm", BusinessTime::Config.end_of_workday
        ran = true
      end
      assert ran
    end

    it "inherits" do
      ran = false
      BusinessTime::Config.with(:end_of_workday => "2pm") do
        BusinessTime::Config.with(:beginning_of_workday => "1pm") do
          assert_equal "1pm", BusinessTime::Config.beginning_of_workday
          assert_equal "2pm", BusinessTime::Config.end_of_workday
          ran = true
        end
      end
      assert ran
    end

    it "resets config after the block" do
      ran = false
      BusinessTime::Config.with(:end_of_workday => "2pm") { ran = true }
      assert ran
      assert_equal "5:00 pm", BusinessTime::Config.end_of_workday
    end

    it "resets config after error" do
      ran = false
      assert_raises RuntimeError do
        BusinessTime::Config.with(:end_of_workday => "2pm") { ran = true; raise }
      end
      assert ran
      assert_equal "5:00 pm", BusinessTime::Config.end_of_workday
    end
  end
end
