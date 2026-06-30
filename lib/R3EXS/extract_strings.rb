# frozen_string_literal: true

require 'zlib'
require_relative 'ast'
require_relative 'utils'
require_relative 'logger'

module R3EXS
  # 提取 R3EXS 格式的 CommonEvent 文件中的字符串
  #
  # @param target_dir [Pathname] 目标目录
  #
  # @raise [JsonDirError] target_dir 不存在
  # @raise [R3EXSJsonFileError] json 文件不是 R3EXS 模块中的对象
  #
  # @return [Array<String>]
  def self.ex_commonevents(target_dir)
    ex_strings = []
    Utils.all_commonevent_json_files(target_dir, :R3EXS) do |commonevents, commonevents_paths, _|
      commonevents.zip(commonevents_paths).each do |commonevent, commonevents_path|
        ex_strings.concat(commonevent.ex_strings)
        Logger.debug("Extract     #{commonevents_path}")
      end
    end
    ex_strings
  end

  # 提取 Ruby 源码中的字符串
  #
  # @param target_dir [Pathname] 目标目录
  # @param with_symbol [Boolean] 是否包含脚本中的符号
  #
  # @raise [JsonDirError] target_dir 不存在
  #
  # @return [Array<String>]
  def self.ex_scripts(target_dir, with_symbol)
    ex_strings = []
    Utils.all_rb_files(target_dir) do |scripts, _, scripts_paths, _, _|
      scripts.zip(scripts_paths).each do |script, scripts_path|
        ex_strings.concat(StringsExtractor.extract(script, with_symbol))
        Logger.debug("Extract     #{scripts_path}")
      end
    end
    ex_strings
  end

  # 提取指定目录下 R3EXS 格式的 JOSN 文件中的字符串
  #
  # @param target_dir [Pathname] 目标目录
  # @param output_dir [Pathname] 输出目录
  # @param with_scripts [Boolean] 是否包含脚本
  # @param with_symbol [Boolean] 是否包含脚本中的符号
  # @param with_scripts_separate [Boolean] 是否将脚本提取的字符串单独存放
  #
  # @raise [JsonDirError] target_dir 不存在
  # @raise [R3EXSJsonFileError] json 文件不是 R3EXS 模块中的对象
  #
  # @return [void]
  def self.ex_strings(target_dir, output_dir, with_scripts, with_symbol, with_scripts_separate)
    all_ex_strings = []

    # 处理 CommonEvent_\d{5}.json 文件
    all_ex_strings.concat(ex_commonevents(target_dir))

    # 处理 Script_\d{3}.rb 文件
    if with_scripts
      rb_strings = ex_scripts(target_dir, with_symbol)
      # 单独输出脚本提取的字符串
      if with_scripts_separate
        Utils.object_json(rb_strings.to_h { |str| [str, str] }, output_dir.join('ManualTransFile_scripts.json'))
      else
        all_ex_strings.concat(rb_strings)
      end
    end

    # 处理常规 JSON 文件
    Utils.all_regular_json_files(target_dir, :R3EXS) do |object, file_path|
      all_ex_strings.concat(Utils.ex_r3exs(object))
      Logger.debug("Extract     #{file_path}")
    end

    # 去除 nil 元素
    all_ex_strings.compact!
    Utils.object_json(all_ex_strings.to_h { |str| [str, str] }, output_dir.join('ManualTransFile.json'))
  end
end
