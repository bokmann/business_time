require 'helper'

class TestConfig < Test::Unit::TestCase

  should "keep track of the start of the day" do
    assert_equal "9:00 am", BusinessTime::Config.beginning_of_workday
    BusinessTime::Config.beginning_of_workday = "8:30 am"
    assert_equal "8:30 am", BusinessTime::Config.beginning_of_workday
  end

  should "keep track of the end of the day" do
    assert_equal "5:00 pm", BusinessTime::Config.end_of_workday
    BusinessTime::Config.end_of_workday = "5:30 pm"
    assert_equal "5:30 pm", BusinessTime::Config.end_of_workday
  end

  should "keep track of holidays" do
    assert BusinessTime::Config.holidays.empty?
    daves_birthday = Date.parse("August 4th, 1969")
    BusinessTime::Config.holidays << daves_birthday
    assert BusinessTime::Config.holidays.include?(daves_birthday)
  end

  should "keep track of work week" do
    assert_equal %w[mon tue wed thu fri], BusinessTime::Config.work_week
    BusinessTime::Config.work_week = %w[sun mon tue wed thu]
    assert_equal %w[sun mon tue wed thu], BusinessTime::Config.work_week
  end

  should "map work week to weekdays" do
    assert_equal [1,2,3,4,5], BusinessTime::Config.weekdays
    BusinessTime::Config.work_week = %w[sun mon tue wed thu]
    assert_equal [0,1,2,3,4], BusinessTime::Config.weekdays
    BusinessTime::Config.work_week = %w[tue wed] # Hey, we got it made!
    assert_equal [2,3], BusinessTime::Config.weekdays
  end

  should "load config from YAML files" do
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
    assert_equal "11:00 am", BusinessTime::Config.beginning_of_workday
    assert_equal "2:00 pm", BusinessTime::Config.end_of_workday
    assert_equal ['mon'], BusinessTime::Config.work_week
    assert_equal [Time.parse('2012-12-25')], BusinessTime::Config.holidays
  end

  should "include holidays read from YAML config files" do
    yaml = <<-YAML
    business_time:
      holidays:
        - May 7th, 2012
    YAML
    assert Time.workday?(Time.parse('2012-05-07'))
    config_file = StringIO.new(yaml.gsub!(/^    /, ''))
    BusinessTime::Config.load(config_file)
    assert !Time.workday?(Time.parse('2012-05-07'))
  end

  should "use defaults for values missing in YAML file" do
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

end
