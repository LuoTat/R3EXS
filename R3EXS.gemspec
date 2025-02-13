# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__), 'lib', 'R3EXS', 'version.rb'])
spec = Gem::Specification.new do |s|
    s.name = 'R3EXS'
    s.version = R3EXS::VERSION
    s.summary = 'A tool for extracting and translating strings from the RGSS3 game engine'
    s.license = 'MIT'
    s.author = 'LuoTat'
    s.email = 'LuoTat.s@gmail.com'
    s.homepage = 'https://github.com/LuoTat'
    s.files = Dir['bin/R3EXS', 'ext/rgss3a_rvdata2/*', 'lib/**/*.rb', 'LICENSE', 'README.md', 'README_EN.md']
    s.bindir = 'bin'
    s.executables << 'R3EXS'
    s.platform = Gem::Platform::RUBY
    s.required_ruby_version = '>= 3.4.1'
    s.require_paths << 'lib'
    s.add_development_dependency('rake', '~> 13.2.1')
    s.add_development_dependency('rake-compiler', '~> 1.2.9') # For building C extension
    s.add_development_dependency('yard', '~> 0.9.37') # For documentation
    s.add_development_dependency('redcarpet', '~> 3.6.0') # For Markdown parsing
    s.add_development_dependency('ocran', '~>1.3.16') # For packaging
    s.add_runtime_dependency('gli', '~> 2.22.1')
    s.add_runtime_dependency('oj', '~> 3.16.9') # For JSON parsing
    s.extensions << './ext/rgss3a_rvdata2/extconf.rb' # Add C extension
end