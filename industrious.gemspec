# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'industrious/version'

Gem::Specification.new do |spec|
  spec.name          = 'industrious'
  spec.version       = Industrious::VERSION
  spec.authors       = ['Michael Webb']
  spec.email         = ['michaelwebb76@gmail.com']

  spec.summary       = 'A simple, powerful Ruby workflow engine'
  spec.description   = 'Industrious is an attempt to address the lack of quality workflow engines available in Ruby'
  spec.homepage      = 'http://github.com/moggyboy/industrious'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  unless spec.respond_to?(:metadata)
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end
  spec.metadata['allowed_push_host'] = "Set to 'http://mygemserver.com'"
  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activerecord', '~> 4.2.7'
  spec.add_dependency 'thor', '~> 0.19'

  spec.add_development_dependency 'sqlite3', '~> 1.3.12'
  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'pry', '~> 0.10.0'
  spec.add_development_dependency 'pry-byebug', '~> 3.1.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
