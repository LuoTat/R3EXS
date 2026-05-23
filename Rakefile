require 'bundler/gem_tasks'
require 'rake/extensiontask'

# 添加 C 扩展构建任务
Rake::ExtensionTask.new('R3EXS') do |ext|
    ext.lib_dir = "lib/R3EXS"
end

# 添加 ocran 打包任务
desc "Run ocran to package the application"
task :ocran do
    # 这里使用 --no-autoload 主要是 prism gem 会自动加载 ruby_parser，导致不必要的依赖
    sh 'ocran --no-autoload --output R3EXS-windows_Ocran.exe .\bin\R3EXS'
end
