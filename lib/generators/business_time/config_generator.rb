module BusinessTime
  module Generators
    class ConfigGenerator < Rails::Generators::Base # :nodoc:
      
      def self.gem_root
        File.expand_path("../../../..", __FILE__)
      end

      def self.source_root
        # Use the templates from the 2.3.x generator
        File.join(gem_root, 'rails_generators', 'business_time_config', 'templates')
      end
      
      def generate
        template 'business_time.rb', File.join('config', 'initializers', 'business_time.rb')
        template 'business_time.yml', File.join('config', 'business_time.yml')
      end
      
    end
  end
end