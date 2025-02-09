# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__), 'lib', 'R3EXS', 'version.rb'])
spec = Gem::Specification.new do |s|
    s.name = 'R3EXS'
    s.version = R3EXS::VERSION
    s.summary = 'A tool for extracting and translating strings from the RGSS3 game engine'
    s.files = `git ls-files`.split("\n")
    s.author = 'LuoTat'
    s.email = 'LuoTat.s@gmail.com'
    s.homepage = 'https://github.com/LuoTat'
    s.license = 'MIT'
    s.bindir = 'bin'
    s.platform = Gem::Platform::RUBY
    s.require_paths << 'lib'
    s.add_development_dependency('rake')
    s.add_development_dependency('rdoc')
    s.add_development_dependency('ocran') # For packaging
    s.add_runtime_dependency('gli', '~> 2.22.1')
    s.add_runtime_dependency('oj') # For JSON parsing
    s.executables << 'R3EXS'
    s.extensions << 'ext/extconf.rb' # Add C extension
    s.extra_rdoc_files = ['README.rdoc', 'R3EXS.rdoc']
    s.rdoc_options << '--title' << 'R3EXS' << '--main' << 'README.rdoc' << '-ri'
end
