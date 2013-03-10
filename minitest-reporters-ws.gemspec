# coding: utf-8
$:.push File.expand_path('../lib', __FILE__)

Gem::Specification.new do |s|
  s.name = "minitest-reporters-ws"
  s.version = "0.0.2"

  s.name          = "minitest-reporters-ws"
  s.authors       = ["David Conner"]
  s.email         = ["dconner.pro@gmail.com"]
  s.description   = %q{A Minitest Reporter that Outputs to a Websocket}
  s.summary       = %q{A Minitest Reporter that Outputs to a Websocked!}
  s.homepage      = "https://github.com/dcunited001/minitest-reporters-ws"
  s.license       = "MIT"

  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]

  if s.respond_to? :specification_version then
    s.specification_version = 1

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<minitest-reporters>, ["~> 0.14"])
      s.add_runtime_dependency(%q<em-websocket>, ["~> 0.3"])
      s.add_runtime_dependency(%q<web-socket-ruby>, ["~> 0.1"])
      s.add_runtime_dependency(%q<ansi>, ["~> 1.4"])
      s.add_runtime_dependency(%q<version>, ["~> 1.0"])
    else
      s.add_dependency(%q<minitest-reporters>, ["~> 0.14"])
      s.add_dependency(%q<em-websocket>, ["~> 0.3"])
      s.add_dependency(%q<web-socket-ruby>, ["~> 0.1"])
      s.add_dependency(%q<ansi>, ["~> 1.4"])
      s.add_dependency(%q<version>, ["~> 1.0"])
    end
  else
    s.add_dependency(%q<minitest-reporters>, ["~> 0.14"])
    s.add_dependency(%q<em-websocket>, ["~> 0.3"])
    s.add_dependency(%q<web-socket-ruby>, ["~> 0.1"])
    s.add_dependency(%q<ansi>, ["~> 1.4"])
    s.add_dependency(%q<version>, ["~> 1.0"])
  end

  s.add_development_dependency "bundler", "~> 1.3"
  s.add_development_dependency "rake"
end
