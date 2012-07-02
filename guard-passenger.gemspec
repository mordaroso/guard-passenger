# encoding: utf-8
$:.push File.expand_path('../lib', __FILE__)
require 'guard/passenger/version'

Gem::Specification.new do |s|
  s.name        = 'guard-passenger'
  s.version     = Guard::PassengerVersion::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Fabio Kuhn']
  s.email       = ['mordaroso@gmail.com']
  s.homepage    = 'http://rubygems.org/gems/guard-passenger'
  s.summary     = 'Guard gem for Passenger'
  s.description = 'Guard::Passenger automatically restarts Passenger when needed.'

  s.required_rubygems_version = '>= 1.3.6'
  s.rubyforge_project         = 'guard-passenger'

  s.add_dependency 'guard', '>= 1.1.0.beta '

  s.add_development_dependency 'bundler',       '~> 1.1.3'
  s.add_development_dependency 'rspec',         '~> 2.10.0'
  s.add_development_dependency 'guard-rspec',   '~> 1.1.0'
  s.add_development_dependency 'guard-bundler', '~> 1.0.0'

  s.files = Dir.glob('{lib}/**/*') + %w[LICENSE README.rdoc]
  s.require_path = 'lib'
end
