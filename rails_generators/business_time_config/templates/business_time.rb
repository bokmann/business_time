BusinessTime::Config.load("#{RAILS_ROOT}/config/business_time.yml")

# or you can configure it manually:  look at me!  I'm Tim Ferris!
#  BusinessTime.Config.beginning_of_workday = "10:00 am"
#  BusinessTime.Comfig.end_of_workday = "11:30 am"
#  BusinessTime.config.holidays << Date.parse("August 4th, 2010")