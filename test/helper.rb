require 'thread'
require 'rubygems'
require 'active_support/version'

if RUBY_VERSION >= '1.9'
  require 'time'
  require 'date'
  require 'active_support/time' if ActiveSupport::VERSION::MAJOR > 2
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
