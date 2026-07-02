# frozen_string_literal: true

require 'zlib'
require_relative 'utils'
require_relative 'logger'

module R3EXS
  # 将 CommonEvents 对象数组序列化为分开的 JSON 文件
  #
  # @param commonevents [Array<RPG::CommonEvent>] CommonEvents 对象数组
  # @param output_dir [Pathname] 输出目录
  # @param complete [Boolean] 是否序列化所有内容
  #
  # @return [void]
  def self.commonevents_json(commonevents, output_dir, complete)
    if complete
      commonevents.each_with_index do |commonevent, index|
        file_path = output_dir.join("#{format('CommonEvent_%05d', index)}.json")
        Utils.object_json(commonevent, file_path)
        Logger.debug("Serialize   #{file_path}")
      end
    else
      commonevents = Utils.rpg_r3exs(commonevents, R3EXS::CommonEvent)
      commonevents.each do |commonevent|
        file_path = output_dir.join("#{format('CommonEvent_%05d', commonevent.index)}.json")
        Utils.object_json(commonevent, file_path)
        Logger.debug("Serialize   #{file_path}")
      end
    end
  end

  # 将 Script 对象数组序列化为分开的 Ruby 源码
  #
  # @param scripts [Array<Object>] Script 对象数组
  # @param output_dir [Pathname] 输出目录
  #
  # @return [void]
  def self.scripts_rb(scripts, output_dir)
    scripts_info = []
    script_info_file_path = output_dir.join('Scripts_info.json')
    scripts.each_with_index do |script, index|
      next if script.nil?

      scripts_info << { index: index, name: script[1] }
      file_path = output_dir.join("#{format('Script_%03d', index)}.rb")
      Utils.script_rb_compressing(script[2], file_path)
      Logger.debug("Serialize   #{file_path}")
    end
    Utils.object_json(scripts_info, script_info_file_path)
    Logger.debug("Serialize   #{script_info_file_path}")
  end

  # 将常规对象数组序列化为 JSON 文件
  #
  # @param obj [Array<Object>] 常规对象数组
  # @param klass [::Class] 对应 R3EXS 模块的类
  # @param file_path [Pathname] 输出文件路径
  # @param complete [Boolean] 是否序列化所有内容
  #
  # @return [void]
  def self.regular_json(obj, klass, file_path, complete)
    if complete
      Utils.object_json(obj, file_path)
    else
      Utils.object_json(Utils.rpg_r3exs(obj, klass), file_path)
    end
    Logger.debug("Serialize   #{file_path}")
  end

  # 将指定目录下的所有 rvdata2 文件序列化为 JSON 格式
  #
  # @param target_dir [Pathname] 目标目录
  # @param output_dir [Pathname] 输出目录
  # @param complete [Boolean] 是否序列化所有内容
  # @param with_scripts [Boolean] 是否包含脚本
  #
  # @raise [Rvdata2DirError] target_dir 不存在
  #
  # @return [void]
  def self.rvdata2_json(target_dir, output_dir, complete, with_scripts)
    Utils.all_rvdata2_files(target_dir) do |obj, klass, file_basename, rvdata2_path|
      file_path = output_dir.join(rvdata2_path.relative_path_from(target_dir)).sub_ext('.json')
      if file_basename.to_s == 'CommonEvents'
        commonevents_json(obj, file_path.sub_ext(''), complete)
      elsif file_basename.to_s == 'Scripts'
        scripts_rb(obj, file_path.sub_ext('')) if with_scripts
      else
        regular_json(obj, klass, file_path, complete)
      end
    end
  end
end
