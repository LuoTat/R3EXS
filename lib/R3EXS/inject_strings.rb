# frozen_string_literal: true

require 'zlib'
require_relative 'ast'
require_relative 'utils'
require_relative 'logger'

module R3EXS
  # 注入 R3EXS 格式的 CommonEvent 文件中的字符串
  #
  # @param target_dir [Pathname] 目标目录
  # @param output_dir [Pathname] 输出目录
  # @param manual_trans_hash[Hash{String => String}] 翻译结果
  #
  # @raise [JsonDirError] target_dir 不存在
  # @raise [R3EXSJsonFileError] json 文件不是 R3EXS 模块中的对象
  #
  # @return [void]
  def self.in_commonevents(target_dir, output_dir, manual_trans_hash)
    Utils.all_commonevent_json_files(target_dir, :R3EXS) do |commonevents, commonevents_paths, _|
      commonevents.zip(commonevents_paths).each do |commonevent, commonevents_path|
        file_path = output_dir.join(commonevents_path.relative_path_from(target_dir))
        commonevent.in_strings(manual_trans_hash)
        Utils.object_json(commonevent, file_path)
        Logger.debug("Inject      #{file_path}")
      end
    end
  end

  # 注入 Ruby 源码中的字符串
  #
  # @param target_dir [Pathname] 目标目录
  # @param output_dir [Pathname] 输出目录
  # @param manual_trans_hash[Hash{String => String}] 翻译结果
  #
  # @raise [JsonDirError] target_dir 不存在
  # @raise [ScriptsInfoPathError] Scripts_info.json 不存在
  #
  # @return [void]
  def self.in_scripts(target_dir, output_dir, manual_trans_hash)
    Utils.all_rb_files(target_dir) do |scripts, script_info, scripts_paths, script_info_path, _|
      scripts.zip(scripts_paths).each do |script, scripts_path|
        file_path = output_dir.join(scripts_path.relative_path_from(target_dir))
        Utils.script_rb(StringsInjector.inject(script, manual_trans_hash), file_path)
        Logger.debug("Inject      #{file_path}")
      end
      Utils.object_json(script_info, output_dir.join(script_info_path.relative_path_from(target_dir)))
    end
  end

  # 将指定目录下 R3EXS 格式的 JOSN 文件按照 ManualTransFile.json 翻译注入字符串
  #
  # @param target_dir [Pathname] 目标目录
  # @param output_dir [Pathname] 输出目录
  # @param manualtransfile_path [Pathname] ManualTransFile.json 文件路径
  # @param with_scripts [Boolean] 是否包含脚本
  #
  # @raise [ManualTransFilePath] ManualTransFile.json 不存在
  # @raise [JsonDirError] target_dir 不存在
  # @raise [R3EXSJsonFileError] json 文件不是 R3EXS 模块中的对象
  # @raise [ScriptsInfoPathError] Scripts_info.json 文件不存在
  #
  # @return [void]
  def self.in_strings(target_dir, output_dir, manualtransfile_path, with_scripts)
    manualtransfile_path.exist? or raise ManualTransFilePathError, "ManualTransFile.json not found: #{manualtransfile_path}"
    manual_trans_hash = Oj.load_file(manualtransfile_path.to_s)

    # 处理 CommonEvent_\d{5}.json 文件
    in_commonevents(target_dir, output_dir, manual_trans_hash)

    # 处理 Script_\d{3}.rb 文件
    in_scripts(target_dir, output_dir, manual_trans_hash) if with_scripts

    # 处理常规的 JSON 文件
    Utils.all_regular_json_files(target_dir, :R3EXS) do |object, json_path|
      file_path = output_dir.join(json_path.relative_path_from(target_dir))
      Utils.in_r3exs(object, manual_trans_hash)
      Utils.object_json(object, file_path)
      Logger.debug("Inject      #{file_path}")
    end
  end
end
