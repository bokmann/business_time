# This generator simply drops the business_time.rb and business_time.yml file
# into the appropate places in a rails app to configure and initialize the
# data.  Once generated, these files are yours to modify.
class BusinessTimeConfigGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.template('business_time.rb', "config/initializers/business_time.rb")
      m.template('business_time.yml', "config/business_time.yml")
    end
  end
end
