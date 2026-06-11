# frozen_string_literal: true

require 'zlib'
require_relative 'utils'

module R3EXS

  # 将指定目录下的所有JSON文件转换为 rvdata2 文件
  #
  # @param [Pathname] target_dir 目标目录
  # @param [Pathname] output_dir 输出目录
  # @param [Pathname] original_dir 原始 rvdata2 文件目录
  # @param [Boolean] complete 是否完全转换
  # @param [Boolean] with_scripts 是否转换Scripts
  #
  # @raise [RPGJsonFileError] json 文件不是 RPG 模块中的对象
  # @raise [R3EXSJsonFileError] json 文件不是 R3EXS 模块中的对象
  # @raise [Rvdata2FileError] 原始 rvdata2 文件可能损坏
  # @raise [JsonDirError] target_dir 不存在
  # @raise [Rvdata2DirError] original_dir 不存在
  # @raise [ScriptsInfoPathError] Scripts_info.json 文件不存在
  #
  # @return [void]
  def R3EXS.json_rvdata2(target_dir, output_dir, original_dir, complete, with_scripts)
    # 处理常规的 JSON 文件
    Utils.all_json_files(target_dir, (complete) ? :RPG : :R3EXS) do |object, file_basename, parent_relative_dir|
      output_file_path = output_dir.join(parent_relative_dir, "#{file_basename}.rvdata2")
      if complete
        print "#{Utils::ESCAPE}#{Utils::MAGENTA_COLOR}Serializing to #{Utils::RESET_COLOR}#{output_file_path}...\r" if $global_options[:verbose]
        Utils.object_rvdata2(object, output_file_path)
      else
        # 检查 original_dir 是否存在
        original_dir.exist? or raise Rvdata2DirError.new(original_dir.to_s), "Original rvdata2 directory not found: #{original_dir}"
        original_file_path = original_dir.join(parent_relative_dir, "#{file_basename}.rvdata2")
        print "#{Utils::ESCAPE}#{Utils::BLUE_COLOR}Reading and Deserializing #{Utils::RESET_COLOR}#{original_file_path}...\r" if $global_options[:verbose]
        original_object = Marshal.load(original_file_path.binread)

        # 这里的类型检查要用紧凑模式，因为 rvdata2 文件中可能存在 nil 元素，必须忽略
        begin
          Utils.check_type(original_object, file_basename, true, :RPG)
        rescue RPGTypeError
          raise Rvdata2FileError.new(original_file_path.to_s), "Invalid rvdata2 file: #{original_file_path}"
        end

        print "#{Utils::ESCAPE}#{Utils::MAGENTA_COLOR}Serializing to #{Utils::RESET_COLOR}#{output_file_path}...\r" if $global_options[:verbose]

        # 根据是否为数组进行不同的处理
        if object.is_a?(Array)
          object.each do |obj|
            obj.inject_to(original_object[obj.index])
          end
        else
          object.inject_to(original_object)
        end
        Utils.object_rvdata2(original_object, output_file_path)
      end
      print "#{Utils::ESCAPE}#{Utils::GREEN_COLOR}Serialized #{Utils::RESET_COLOR}#{output_file_path}\n" if $global_options[:verbose]
    end

    # 处理 CommonEvent_\d{5}.json 文件
    Utils.all_commonevent_json_files(target_dir, (complete) ? :RPG : :R3EXS) do |commonevents, _, parent_relative_dir|
      output_file_path = output_dir.join(parent_relative_dir.parent, 'CommonEvents.rvdata2')
      if complete
        print "#{Utils::ESCAPE}#{Utils::MAGENTA_COLOR}Serializing to #{Utils::RESET_COLOR}#{output_file_path}...\r" if $global_options[:verbose]
        Utils.object_rvdata2(commonevents, output_file_path)
      else
        # 检查 original_dir 是否存在
        original_dir.exist? or raise Rvdata2DirError.new(original_dir.to_s), "Original rvdata2 directory not found: #{original_dir}"
        original_file_path = original_dir.join(parent_relative_dir.parent, 'CommonEvents.rvdata2')
        print "#{Utils::ESCAPE}#{Utils::BLUE_COLOR}Reading and Deserializing #{Utils::RESET_COLOR}#{original_file_path}...\r" if $global_options[:verbose]
        original_object = Marshal.load(original_file_path.binread)

        # 这里的类型检查要用紧凑模式，因为 rvdata2 文件中可能存在 nil 元素，必须忽略
        begin
          Utils.check_type(original_object, 'CommonEvents', true, :RPG)
        rescue RPGTypeError
          raise Rvdata2FileError.new(original_file_path.to_s), "Invalid rvdata2 file: #{original_file_path}"
        end

        print "#{Utils::ESCAPE}#{Utils::MAGENTA_COLOR}Serializing to #{Utils::RESET_COLOR}#{output_file_path}...\r" if $global_options[:verbose]

        commonevents.each do |commonevent|
          commonevent.inject_to(original_object[commonevent.index])
        end

        Utils.object_rvdata2(original_object, output_file_path)
      end
      print "#{Utils::ESCAPE}#{Utils::GREEN_COLOR}Serialized #{Utils::RESET_COLOR}#{output_file_path}\n" if $global_options[:verbose]
    end

    # 处理 \d{5}.rb 文件
    if with_scripts
      Utils.all_rb_files(target_dir) do |scripts, _, parent_relative_dir|
        output_file_path = output_dir.join(parent_relative_dir.parent, 'Scripts.rvdata2')
        script_info_file_path = target_dir.join(parent_relative_dir, 'Scripts_info.json')
        script_info_file_path.exist? or raise ScriptsInfoPathError.new(script_info_file_path.to_s), "Scripts_info.json not found: #{script_info_file_path}"

        print "#{Utils::ESCAPE}#{Utils::MAGENTA_COLOR}Serializing to #{Utils::RESET_COLOR}#{output_file_path}...\r" if $global_options[:verbose]

        print "#{Utils::ESCAPE}#{Utils::YELLOW_COLOR}Reading from #{Utils::RESET_COLOR}#{script_info_file_path}...\r" if $global_options[:verbose]
        scripts_info_array = Oj.load_file(script_info_file_path.to_s)

        output_scripts_array = []
        scripts_info_array.each do |script_info|
          index = script_info[:index]
          script = scripts[index]
          output_scripts_array << [114514, script_info[:name], Zlib::Deflate.deflate(script)]
        end
        Utils.object_rvdata2(output_scripts_array, output_file_path)
        print "#{Utils::ESCAPE}#{Utils::GREEN_COLOR}Serialized #{Utils::RESET_COLOR}#{output_file_path}\n" if $global_options[:verbose]
      end
    end
  end

end
