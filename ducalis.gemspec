
# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ducalis/version'

Gem::Specification.new do |spec|
  spec.name          = 'ducalis'
  spec.version       = Ducalis::VERSION
  spec.authors       = ['Ignat Zakrevsky']
  spec.email         = ['iezakrevsky@gmail.com']
  spec.summary       = 'RuboCop based static code analyzer'
  spec.description   = <<-DESCRIPTION
    Ducalis is RuboCop based static code analyzer for enterprise Rails \
    applications.
  DESCRIPTION

  spec.homepage      = 'https://github.com/ignat-z/ducalis'
  spec.license       = 'MIT'

  if spec.respond_to?(:metadata)
    spec.metadata['source_code_uri'] = 'https://github.com/ignat-z/ducalis'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features|Dockerfile)/})
  end
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }

  spec.add_dependency 'policial', '0.0.4'
  spec.add_dependency 'rubocop', '~> 0.50.0'
  spec.add_dependency 'regexp-examples', '~> 1.3', '>= 1.3.2'
  spec.add_dependency 'thor', '~> 0.20.0'

  spec.add_development_dependency 'bundler', '~> 1.16.a'
  spec.add_development_dependency 'rake', '~> 12.1'
  spec.add_development_dependency 'rspec', '~> 3.0'
end