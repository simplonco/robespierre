# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "arduino_firmata"
  s.version = "0.3.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Sho Hashimoto"]
  s.date = "2014-02-01"
  s.description = "Arduino Firmata protocol (http://firmata.org) implementation on Ruby."
  s.email = ["hashimoto@shokai.org"]
  s.executables = ["arduino_firmata"]
  s.files = ["bin/arduino_firmata"]
  s.homepage = "http://shokai.github.com/arduino_firmata"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.3"
  s.summary = "Arduino Firmata protocol (http://firmata.org) implementation on Ruby."

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.3"])
      s.add_development_dependency(%q<minitest>, [">= 0"])
      s.add_development_dependency(%q<backports>, [">= 0"])
      s.add_runtime_dependency(%q<serialport>, [">= 1.1.0"])
      s.add_runtime_dependency(%q<args_parser>, [">= 0.1.4"])
      s.add_runtime_dependency(%q<event_emitter>, [">= 0.2.4"])
    else
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<bundler>, ["~> 1.3"])
      s.add_dependency(%q<minitest>, [">= 0"])
      s.add_dependency(%q<backports>, [">= 0"])
      s.add_dependency(%q<serialport>, [">= 1.1.0"])
      s.add_dependency(%q<args_parser>, [">= 0.1.4"])
      s.add_dependency(%q<event_emitter>, [">= 0.2.4"])
    end
  else
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<bundler>, ["~> 1.3"])
    s.add_dependency(%q<minitest>, [">= 0"])
    s.add_dependency(%q<backports>, [">= 0"])
    s.add_dependency(%q<serialport>, [">= 1.1.0"])
    s.add_dependency(%q<args_parser>, [">= 0.1.4"])
    s.add_dependency(%q<event_emitter>, [">= 0.2.4"])
  end
end
