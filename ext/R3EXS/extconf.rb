# frozen_string_literal: true

require 'mkmf'

$CXXFLAGS << ' -std=c++23' # 添加对C++23的支持

if RbConfig::CONFIG['host_os'] =~ /mswin|mingw|cygwin/
  $CXXFLAGS << ' -march=native' # 启用针对本地CPU的优化
  have_library('stdc++exp') # 在Windows上链接stdc++exp库以支持C++23特性
end

create_makefile('R3EXS/R3EXS')
