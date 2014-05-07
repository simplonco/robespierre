lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'args_parser/version'

Gem::Specification.new do |gem|
  gem.name          = "args_parser"
  gem.version       = ArgsParser::VERSION
  gem.authors       = ["Sho Hashimoto"]
  gem.email         = ["hashimoto@shokai.org"]
  gem.description   = %q{Parse/Filter/Validate ARGV from command line with DSL.}
  gem.summary       = gem.description
  gem.homepage      = "http://shokai.github.com/args_parser"
  gem.license       = "MIT"

  gem.files         = `git ls-files`.split($/).reject{|i| i=="Gemfile.lock" }
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "rake"
  gem.add_development_dependency "bundler", "~> 1.3"
  gem.add_development_dependency 'minitest'
  gem.add_development_dependency 'json'
end
