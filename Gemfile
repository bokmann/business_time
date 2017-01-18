source "https://rubygems.org"
gemspec

group :test, :development do
  if RUBY_VERSION.to_i < 2
    gem 'rake', '>= 0.8.7', '<= 10.4.2'
    gem 'json', '< 2'
  else
    gem 'rake'
  end
end

# ActiveSupport 5.0.1 requires ruby > 2.2.2
if RUBY_VERSION.split('.').join('').to_i < 222
  gem 'activesupport', '>= 3.1.0', '< 5'
else
  gem 'activesupport', '>= 3.1.0'
end
