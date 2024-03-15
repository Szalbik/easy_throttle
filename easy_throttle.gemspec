Gem::Specification.new do |s|
  s.name        = 'EasyThrottle'
  s.version     = '0.0.1'
  s.licenses    = ['MIT']
  s.summary     = "Allows you to throttle requests to an API."
  s.authors     = ["Damian Szalbierz"]
  s.email       = 'szalbierz.d.k@gmail.com'
  s.homepage    = 'https://github.com/Szalbik/easy_throttle'
  s.files       = Dir["lib/**/*.rb"] + ["lib/config.yml"]
  s.add_runtime_dependency 'redis', '>= 4.0'
end