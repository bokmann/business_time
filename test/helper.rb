require 'thread'
require 'rubygems'

if ENV["COV"]
  require 'simplecov'
  SimpleCov.start
end

if RUBY_VERSION >= '1.9'
  require 'time'
  require 'date'
  require 'active_support/time'
else
  require 'active_support'
  require 'active_support/core_ext'
end

require 'test/unit'
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'business_time'

class Test::Unit::TestCase
  def teardown
    BusinessTime::Config.reset
  end
end
