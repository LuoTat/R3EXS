# frozen_string_literal: true

require 'zlib'
require_relative 'utils'
require_relative 'logger'

module R3EXS
  # 将 CommonEvents 对象数组序列化为分开的 JSON 文件
  #
  # @param commonevents [Array<RPG::CommonEvent>] 待转换的 CommonEvents 对象数组
  # @param output_dir [Pathname] 输出目录
  # @param complete [Boolean] 是否序列化所有内容
  # @param with_notes [Boolean] 是否包含备注
  #
  # @return [void]
  def self.commonevents_json(commonevents, output_dir, complete, with_notes)
    full_dir = output_dir.join('CommonEvents')

    if complete
      commonevents.each_with_index do |commonevent, index|
        commonevent_file_path = full_dir.join("#{format('CommonEvent_%05d', index)}.json")
        Logger.debug("Serializing to #{commonevent_file_path}...")
        Utils.object_json(commonevent, commonevent_file_path)
        Logger.debug("Serialized #{commonevent_file_path}")
      end
    else
      commonevents = Utils.rpg_r3exs(commonevents, 'CommonEvents', with_notes)
      commonevents.each do |commonevent|
        index = commonevent.index
        commonevent_file_path = full_dir.join("#{format('CommonEvent_%05d', index)}.json")
        Logger.debug("Serializing to #{commonevent_file_path}...")
        Utils.object_json(commonevent, commonevent_file_path)
        Logger.debug("Serialized #{commonevent_file_path}")
      end
    end
  end

  # 将 Script 对象数组序列化为 Ruby 源码
  #
  # @param scripts [Array<Object>] 待转换的 Script 对象数组
  # @param output_dir [Pathname] 输出目录
  #
  # @return [void]
  def self.scripts_rb(scripts, output_dir)
    output_dir.mkpath unless output_dir.exist?
    full_dir = output_dir.join('Scripts')
    full_dir.mkdir unless full_dir.exist?

    scripts_info_array = []
    scripts.each_with_index do |script, index|
      next if script.nil?

      scripts_info_array << { index: index, name: script[1] }
      script_file_path = full_dir.join("#{format('%03d', index)}.rb")
      Logger.debug("Serializing to #{script_file_path}...")
      script_file_path.write(Zlib::Inflate.inflate(script[2]).encode(universal_newline: true))
      Logger.debug("Serialized #{script_file_path}")
    end

    script_info_file_path = full_dir.join('Scripts_info.json')
    Logger.debug("Serializing to #{script_info_file_path}")
    Utils.object_json(scripts_info_array, script_info_file_path)
    Logger.debug("Serialized #{script_info_file_path}")
  end

  # 将指定目录下的所有 rvdata2 文件序列化为 JSON 格式
  #
  # @param target_dir [Pathname] 目标目录
  # @param output_dir [Pathname] 输出目录
  # @param complete [Boolean] 是否序列化所有内容
  # @param with_scripts [Boolean] 是否包含脚本
  # @param with_notes [Boolean] 是否包含备注
  #
  # @raise [Rvdata2FileError] rvdata2 文件可能损坏
  # @raise [Rvdata2DirError] target_dir 不存在
  #
  # @return [void]
  def self.rvdata2_json(target_dir, output_dir, complete, with_scripts, with_notes)
    Utils.all_rvdata2_files(target_dir) do |object, file_basename, parent_relative_dir|
      full_output_dir = output_dir.join(parent_relative_dir)
      if file_basename == 'CommonEvents'
        commonevents_json(object, full_output_dir, complete, with_notes)
      elsif with_scripts && (file_basename == 'Scripts')
        scripts_rb(object, full_output_dir)
      else
        file_path = full_output_dir.join("#{file_basename}.json")
        Logger.debug("Serializing to #{file_path}...")
        if complete
          Utils.object_json(object, file_path)
        else
          Utils.object_json(Utils.rpg_r3exs(object, file_basename, with_notes), file_path)
        end
        Logger.debug("Serialized #{file_path}")
      end
    end
  end
end
