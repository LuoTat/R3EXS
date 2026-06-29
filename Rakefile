# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rake/extensiontask'

# 添加 C 扩展构建任务
Rake::ExtensionTask.new('R3EXS') do |ext|
  ext.lib_dir = 'lib/R3EXS'
end

# 清理文件
desc 'Clean up generated files'
task :clean do
  rm_rf %w[
    ./Data
    ./Data_NEW
    ./Graphics
    ./JSON
    ./JSON_NEW
    ./doc
    ./pkg
    ./tmp
    ./ManualTransFile.json
    ./ManualTransFile_scripts.json
  ]
end
