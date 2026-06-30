# frozen_string_literal: true

# Ensure we require the local version and not one we might have installed already.
require File.join(__dir__, 'lib', 'R3EXS', 'version.rb')
Gem::Specification.new do |s|
  s.name = 'R3EXS'
  s.version = R3EXS::VERSION
  s.summary = 'A tool for extracting and translating strings from the RGSS3 game engine'
  s.license = 'MIT'
  s.author = 'LuoTat'
  s.email = 'LuoTat.s@gmail.com'
  s.homepage = 'https://github.com/LuoTat/R3EXS'
  s.metadata = {
    'bug_tracker_uri' => 'https://github.com/LuoTat/R3EXS/issues',
    'changelog_uri' => 'https://github.com/LuoTat/R3EXS/blob/main/CHANGELOG.md',
    'documentation_uri' => 'https://rubydoc.info/gems/R3EXS',
    'source_code_uri' => 'https://github.com/LuoTat/R3EXS'
  }
  s.files = Dir[
    'bin/R3EXS',
    '{lib,ext}/**/*.{rb,cxx}',
    '.yardopts',
    'CHANGELOG.md',
    'LICENSE',
    'README.md',
    'README_EN.md'
  ]
  s.bindir = 'bin'
  s.executables << 'R3EXS'
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 3.0.0'
  s.add_development_dependency('rake', '~> 13.4.2')
  s.add_development_dependency('rake-compiler', '~> 1.3.1') # For building C extension
  s.add_development_dependency('rubocop', '~> 1.87') # For code linting
  s.add_development_dependency('yard', '~> 0.9.44') # For documentation
  s.add_runtime_dependency('gli', '~> 2.22.2') # For command line interface
  s.add_runtime_dependency('oj', '~> 3.17.3') # For JSON parsing
  s.extensions << './ext/R3EXS/extconf.rb' # Add C extension
end
