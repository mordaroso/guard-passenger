source 'http://rubygems.org'

# Specify your gem's dependencies in guard-passenger.gemspec
gemspec

group :development do
  # optional development dependencies
  require 'rbconfig'

  gem 'guard-bundler'
  gem 'guard-rspec'

  if Config::CONFIG['target_os'] =~ /darwin/i
    gem 'rb-fsevent', '>= 0.3.2'
    gem 'growl', '~> 1.0.3'
  end
  if Config::CONFIG['target_os'] =~ /linux/i
    gem 'rb-inotify', '>= 0.5.1'
    gem 'libnotify', '~> 0.1.3'
  end
end
