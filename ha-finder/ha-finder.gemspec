lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'version'

Gem::Specification.new do |gem|
  gem.name          = 'ha-finder'
  gem.version       = HaFinder::VERSION
  gem.authors       = ['Logan McDonald']
  gem.email         = ['logan@logancodes.it']
  gem.description   = %q{Use this command line tool to find homograph attacks.}
  gem.summary       = %q{Finds available domains to be used in homograph attacks.}
  gem.homepage      = 'https://github.com/loganmeetsworld/ha-finder'
  gem.license       = "MIT"

  gem.files         = `git ls-files`.split($/)
  gem.files         -= gem.files.grep(%r{^\.})
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.require_paths = ['lib']

  gem.add_dependency "whois", "~> 4.0"
  gem.add_dependency "whois-parser", "~> 1.0"
  gem.add_dependency "simpleidn", "~> 0.0"
end