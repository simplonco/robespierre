# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "args_parser"
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Sho Hashimoto"]
  s.date = "2013-08-26"
  s.description = "Parse/Filter/Validate ARGV from command line with DSL."
  s.email = ["hashimoto@shokai.org"]
  s.homepage = "http://shokai.github.com/args_parser"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.3"
  s.summary = "Parse/Filter/Validate ARGV from command line with DSL."

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.3"])
      s.add_development_dependency(%q<minitest>, [">= 0"])
      s.add_development_dependency(%q<json>, [">= 0"])
    else
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<bundler>, ["~> 1.3"])
      s.add_dependency(%q<minitest>, [">= 0"])
      s.add_dependency(%q<json>, [">= 0"])
    end
  else
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<bundler>, ["~> 1.3"])
    s.add_dependency(%q<minitest>, [">= 0"])
    s.add_dependency(%q<json>, [">= 0"])
  end
end
