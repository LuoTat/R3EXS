# frozen_string_literal: true

require 'zlib'
require_relative 'ast'
require_relative 'utils'

module R3EXS
  # 将指定目录下的所有已经序列化为 R3EXS 后的 JOSN 文件按照 ManualTransFile.json 翻译注入
  #
  # @param target_dir [Pathname] 目标目录
  # @param output_dir [Pathname] 输出目录
  # @param manualtransfile_path [Pathname] ManualTransFile.json 文件路径
  # @param with_scripts [Boolean] 是否包含脚本
  #
  # @raise [R3EXSJsonFileError] json 文件不是 R3EXS 模块中的对象
  # @raise [JsonDirError] target_dir 不存在
  # @raise [ScriptsInfoPathError] Scripts_info.json 文件不存在
  # @raise [ManualTransFilePath] ManualTransFile.json 不存在
  #
  # @return [void]
  def self.in_strings(target_dir, output_dir, manualtransfile_path, with_scripts)
    manualtransfile_path.exist? or raise ManualTransFilePathError.new(manualtransfile_path.to_s), "ManualTransFile.json not found: #{manualtransfile_path}"

    manual_trans_hash = Oj.load_file(manualtransfile_path.to_s)

    # 处理常规的 JSON 文件
    Utils.all_json_files(target_dir, :R3EXS) do |object, file_basename, parent_relative_dir|
      file_path = output_dir.join(parent_relative_dir, "#{file_basename}.json")
      if $global_options[:verbose]
        print "#{Utils::ESCAPE}#{Utils::MAGENTA_COLOR}Injecting to #{Utils::RESET_COLOR}#{file_path}...\r"
      end
      if object.is_a?(Array)
        object.each do |obj|
          obj.in_strings(manual_trans_hash)
        end
      else
        object.in_strings(manual_trans_hash)
      end
      Utils.object_json(object, file_path)
      if $global_options[:verbose]
        print "#{Utils::ESCAPE}#{Utils::GREEN_COLOR}Injected #{Utils::RESET_COLOR}#{file_path}\n"
      end
    end

    # 处理 CommonEvent_\d{5}.json 文件
    Utils.all_commonevent_json_files(target_dir, :R3EXS) do |commonevents, commonevents_basenames, parent_relative_dir|
      commonevents.zip(commonevents_basenames).each do |commonevent, commonevent_basename|
        file_path = output_dir.join(parent_relative_dir, "#{commonevent_basename}.json")
        if $global_options[:verbose]
          print "#{Utils::ESCAPE}#{Utils::MAGENTA_COLOR}Injecting to #{Utils::RESET_COLOR}#{file_path}...\r"
        end
        commonevent.in_strings(manual_trans_hash)
        Utils.object_json(commonevent, file_path)
        if $global_options[:verbose]
          print "#{Utils::ESCAPE}#{Utils::GREEN_COLOR}Injected #{Utils::RESET_COLOR}#{file_path}\n"
        end
      end
    end

    # 处理 \d{5}.rb 文件
    return unless with_scripts

    Utils.all_rb_files(target_dir) do |scripts, scripts_basenames, parent_relative_dir|
      full_output_dir = output_dir.join(parent_relative_dir)
      full_output_dir.mkdir unless full_output_dir.exist?

      script_info_file_path = target_dir.join(parent_relative_dir, 'Scripts_info.json')
      script_info_file_path.exist? or raise ScriptsInfoPathError.new(script_info_file_path.to_s), "Scripts_info.json not found: #{script_info_file_path}"
      # 记得把 Scripts_info.json  也复制过去
      FileUtils.cp(script_info_file_path, full_output_dir)

      scripts.zip(scripts_basenames).each do |script, script_basename|
        output_file_path = full_output_dir.join("#{script_basename}.rb")
        output_file_path.binwrite(StringsInjector.new(manual_trans_hash).rewrite(script, Prism.parse(script).value))
        if $global_options[:verbose]
          print "#{Utils::ESCAPE}#{Utils::GREEN_COLOR}Injected #{Utils::RESET_COLOR}#{output_file_path}\n"
        end
      end
    end
  end
end
