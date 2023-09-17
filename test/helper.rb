require 'minitest/autorun'
require 'minitest/reporters'
if ENV["CI"] == "true"
  Minitest::Reporters.use! Minitest::Reporters::DefaultReporter.new
else
  Minitest::Reporters.use! Minitest::Reporters::ProgressReporter.new
end

if ENV["COV"]
  require 'simplecov'
  SimpleCov.start
end

require 'business_time'

Minitest::Spec.class_eval do
  after do
    BusinessTime::Config.send(:reset)
    Time.zone = nil
  end
end
