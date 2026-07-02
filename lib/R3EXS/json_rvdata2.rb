# frozen_string_literal: true

require 'zlib'
require_relative 'utils'
require_relative 'logger'

module R3EXS
  # 将 CommonEvent 文件反序列化为 rvdata2 文件
  #
  # @param target_dir [Pathname]  目标目录
  # @param output_dir [Pathname]  输出目录
  # @param original_dir [Pathname]  原始 rvdata2 文件目录
  # @param complete [Boolean]  是否完全转换
  #
  # @raise [JsonDirError] target_dir 不存在
  # @raise [RPGJsonFileError] json 文件不是 RPG 模块中的对象
  # @raise [R3EXSJsonFileError] json 文件不是 R3EXS 模块中的对象
  # @raise [Rvdata2PathError] 原始 rvdata2 文件不存在
  #
  # @return [void]
  def self.commonevents_rvdata2(target_dir, output_dir, original_dir, complete)
    if complete
      Utils.all_commonevent_json_files(target_dir, :RPG) do |commonevents, _, rvdata2_file_path|
        file_path = output_dir.join(rvdata2_file_path.relative_path_from(target_dir))
        Utils.object_rvdata2(commonevents, file_path)
        Logger.debug("Serialize   #{file_path}")
      end
    else
      Utils.all_commonevent_json_files(target_dir, :R3EXS) do |commonevents, _, rvdata2_file_path|
        file_path = output_dir.join(rvdata2_file_path.relative_path_from(target_dir))
        original_file_path = original_dir.join(rvdata2_file_path.relative_path_from(target_dir))
        # 检查 original_file_path 是否存在
        original_file_path.exist? or raise Rvdata2PathError, "Original rvdata2 file not found: #{original_file_path}"

        original_commonevents = Marshal.load(original_file_path.binread)
        Logger.debug("Deserialize #{original_file_path}")
        Utils.r3exs_rpg(commonevents, original_commonevents)
        Utils.object_rvdata2(original_commonevents, file_path)
        Logger.debug("Serialize   #{file_path}")
      end
    end
  end

  # 将 Ruby 源码反序列化为 rvdata2 文件
  #
  # @param target_dir [Pathname] 目标目录
  # @param output_dir [Pathname] 输出目录
  #
  # @raise [JsonDirError] target_dir 不存在
  # @raise [ScriptsInfoPathError] Scripts_info.json 不存在
  #
  # @return [void]
  def self.scripts_rvdata2(target_dir, output_dir)
    Utils.all_rb_files(target_dir) do |scripts, script_info, _, _, rvdata2_file_path|
      file_path = output_dir.join(rvdata2_file_path.relative_path_from(target_dir))

      output_scripts = []
      script_info.each do |info|
        index = info[:index]
        script = scripts[index]
        output_scripts << [114_514, info[:name], Zlib::Deflate.deflate(script)]
      end
      Utils.object_rvdata2(output_scripts, file_path)
      Logger.debug("Serialize   #{file_path}")
    end
  end

  # 将常规 JSON 文件反序列化为 rvdata2 文件
  #
  # @param target_dir [Pathname]  目标目录
  # @param output_dir [Pathname]  输出目录
  # @param original_dir [Pathname]  原始 rvdata2 文件目录
  # @param complete [Boolean]  是否完全转换
  #
  # @raise [JsonDirError] target_dir 不存在
  # @raise [RPGJsonFileError] json 文件不是 RPG 模块中的对象
  # @raise [R3EXSJsonFileError] json 文件不是 R3EXS 模块中的对象
  # @raise [Rvdata2PathError] 原始 rvdata2 文件不存在
  #
  # @return [void]
  def self.regular_rvdata2(target_dir, output_dir, original_dir, complete)
    if complete
      Utils.all_regular_json_files(target_dir, :RPG) do |obj, obj_path|
        file_path = output_dir.join(obj_path.relative_path_from(target_dir)).sub_ext('.rvdata2')
        Utils.object_rvdata2(obj, file_path)
        Logger.debug("Serialize   #{file_path}")
      end
    else
      Utils.all_regular_json_files(target_dir, :R3EXS) do |obj, obj_path|
        file_path = output_dir.join(obj_path.relative_path_from(target_dir)).sub_ext('.rvdata2')
        original_file_path = original_dir.join(obj_path.relative_path_from(target_dir)).sub_ext('.rvdata2')
        # 检查 original_file_path 是否存在
        original_file_path.exist? or raise Rvdata2PathError, "Original rvdata2 file not found: #{original_file_path}"

        original_object = Marshal.load(original_file_path.binread)
        Logger.debug("Deserialize #{original_file_path}")
        Utils.r3exs_rpg(obj, original_object)
        Utils.object_rvdata2(original_object, file_path)
        Logger.debug("Serialize   #{file_path}")
      end
    end
  end

  # 将指定目录下的所有JSON文件反序列化为 rvdata2 文件
  #
  # @param target_dir [Pathname]  目标目录
  # @param output_dir [Pathname]  输出目录
  # @param original_dir [Pathname]  原始 rvdata2 文件目录
  # @param complete [Boolean]  是否完全转换
  # @param with_scripts [Boolean]  是否转换Scripts
  #
  # @raise [JsonDirError] target_dir 不存在
  # @raise [RPGJsonFileError] json 文件不是 RPG 模块中的对象
  # @raise [R3EXSJsonFileError] json 文件不是 R3EXS 模块中的对象
  # @raise [Rvdata2PathError] 原始 rvdata2 文件不存在
  # @raise [ScriptsInfoPathError] Scripts_info.json 文件不存在
  #
  # @return [void]
  def self.json_rvdata2(target_dir, output_dir, original_dir, complete, with_scripts)
    # 处理 CommonEvent_\d{5}.json 文件
    commonevents_rvdata2(target_dir, output_dir, original_dir, complete)

    # 处理 Script_\d{3}.rb 文件
    scripts_rvdata2(target_dir, output_dir) if with_scripts

    # 处理常规 JSON 文件
    regular_rvdata2(target_dir, output_dir, original_dir, complete)
  end
end
