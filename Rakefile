require 'rake/clean'
require 'rubygems'
require 'rdoc/task'
require 'rubygems/package_task'
require 'rake/extensiontask'

# 生成 RDoc 文档
Rake::RDocTask.new do |rd|
    rd.main = "README.rdoc"
    rd.rdoc_files.include("README.rdoc", "lib/**/*.rb", "bin/**/*")
    rd.title = 'R3EXS Documentation'
end

# 加载 gemspec 文件
spec = Gem::Specification.load("R3EXS.gemspec")

# 任务：创建 .gem 文件
Gem::PackageTask.new(spec) do |pkg|
end

Rake::ExtensionTask.new("R3EXS", spec) do |ext|
    ext.lib_dir = "lib/R3EXS"
end