# frozen_string_literal: true

# R3EXS 主模块
module R3EXS
  require_relative 'R3EXS/version'
  require_relative 'R3EXS/error'
  require_relative 'R3EXS/rvdata2_json'
  require_relative 'R3EXS/json_rvdata2'
  require_relative 'R3EXS/extract_strings'
  require_relative 'R3EXS/inject_strings'

  require_relative 'R3EXS/R3EXS' # C extension
end
