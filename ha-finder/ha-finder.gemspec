Gem::Specification.new do |s|
  s.name        = 'ha-finder'
  s.version     = '0.0.0'
  s.date        = '2018-02-08'
  s.summary     = "A finder of homograph attack DNS entries."
  s.authors     = ["Logan McDonald"]
  s.email       = 'loganmcdona11@gmail.com'
  s.files       = ["lib/ha-finder.rb"]
  s.license     = 'MIT'

  s.add_dependency "whois", "~> 4.0"
  s.add_dependency "whois-parser", "~> 1.0"
  s.add_dependency "simpleidn", "~> 0.0"
end