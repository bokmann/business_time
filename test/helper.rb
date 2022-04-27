require 'minitest/autorun'
require 'minitest/rg'

if ENV["COV"]
  require 'simplecov'
  SimpleCov.start
end

require 'business_time'

MiniTest::Spec.class_eval do
  after do
    BusinessTime::Config.send(:reset)
    Time.zone = nil
  end
end
