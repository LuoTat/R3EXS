# frozen_string_literal: true

require 'zlib'
require_relative 'ast'
require_relative 'utils'

module R3EXS

  # 将指定目录下的所有已经序列化为 R3EXS 后的 JOSN 文件中的字符串提取出来
  #
  # @param target_dir [Pathname] 目标目录
  # @param output_dir [Pathname] 输出目录
  # @param with_scripts [Boolean] 是否包含脚本
  # @param with_symbol [Boolean] 是否包含脚本中的符号
  # @param with_scripts_separate [Boolean] 是否将脚本提取的字符串单独存放
  #
  # @raise [R3EXSJsonFileError] json 文件不是 R3EXS 模块中的对象
  # @raise [JsonDirError] target_dir 不存在
  #
  # @return [void]
  def R3EXS.ex_strings(target_dir, output_dir, with_scripts, with_symbol, with_scripts_separate)
    all_ex_strings = []

    # 处理常规的 JSON 文件
    Utils.all_json_files(target_dir, :R3EXS) do |object, file_basename, parent_relative_dir|
      file_path = target_dir.join(parent_relative_dir, "#{file_basename}.json")
      print "#{Utils::ESCAPE}#{Utils::MAGENTA_COLOR}Extracting from #{Utils::RESET_COLOR}#{file_path}...\r" if $global_options[:verbose]
      if object.is_a?(Array)
        object.each do |obj|
          all_ex_strings.concat(obj.ex_strings)
        end
      else
        all_ex_strings.concat(object.ex_strings)
      end
      print "#{Utils::ESCAPE}#{Utils::GREEN_COLOR}Extracted #{Utils::RESET_COLOR}#{file_path}\n" if $global_options[:verbose]
    end

    # 处理 CommonEvent_\d{5}.json 文件
    Utils.all_commonevent_json_files(target_dir, :R3EXS) do |commonevents, commonevents_basenames, parent_relative_dir|
      commonevents.zip(commonevents_basenames).each do |commonevent, commonevent_basename|
        file_path = target_dir.join(parent_relative_dir, "#{commonevent_basename}.json")
        print "#{Utils::ESCAPE}#{Utils::MAGENTA_COLOR}Extracting from #{Utils::RESET_COLOR}#{file_path}...\r" if $global_options[:verbose]
        all_ex_strings.concat(commonevent.ex_strings)
        print "#{Utils::ESCAPE}#{Utils::GREEN_COLOR}Extracted #{Utils::RESET_COLOR}#{file_path}\n" if $global_options[:verbose]
      end
    end

    # 处理 \d{5}.rb 文件
    if with_scripts
      all_rb_strings = []
      strings_extractor = StringsExtractor.new(all_rb_strings, with_symbol)

      Utils.all_rb_files(target_dir) do |scripts, scripts_basenames, parent_relative_dir|
        scripts.zip(scripts_basenames).each do |script, script_basename|
          file_path = target_dir.join(parent_relative_dir, "#{script_basename}.rb")
          print "#{Utils::ESCAPE}#{Utils::MAGENTA_COLOR}Extracting from #{Utils::RESET_COLOR}#{file_path}...\r" if $global_options[:verbose]
          strings_extractor.visit(Prism.parse(script).value)
          print "#{Utils::ESCAPE}#{Utils::GREEN_COLOR}Extracted #{Utils::RESET_COLOR}#{file_path}\n" if $global_options[:verbose]
        end
      end

      if with_scripts_separate
        # 去除 nil 元素
        all_rb_strings.compact!
        Utils.object_json(all_rb_strings.each_with_object({}) { |item, h| h[item] = item }, output_dir.join('ManualTransFile_scripts.json'))
      else
        all_ex_strings.concat(all_rb_strings)
      end
    end

    # 去除 nil 元素
    all_ex_strings.compact!
    Utils.object_json(all_ex_strings.each_with_object({}) { |item, h| h[item] = item }, output_dir.join('ManualTransFile.json'))
  end

end
