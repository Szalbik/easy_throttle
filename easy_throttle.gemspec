# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'easy_throttle/version'

Gem::Specification.new do |s|
  s.name        = 'EasyThrottle'
  s.version     = EasyThrottle::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Damian Szalbierz"]
  s.email       = ['szalbierz.d.k@gmail.com']
  s.homepage    = 'https://github.com/Szalbik/easy_throttle'
  s.summary     = "Allows you to throttle requests to an API."
  s.licenses    = ['MIT']
  
  s.add_runtime_dependency 'redis', '>= 4.0'
  
  s.files       = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ['lib']
end
