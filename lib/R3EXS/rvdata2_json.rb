# frozen_string_literal: true

require 'zlib'
require_relative 'utils'

module R3EXS

    # 将 Script 对象数组序列化为 Ruby 源码
    #
    # @param scripts [Array<Object>] 待转换的 Script 对象数组
    # @param output_dir [Pathname] 输出目录
    #
    # @return [void]
    def R3EXS.scripts_rb(scripts, output_dir)
        output_dir.mkpath unless output_dir.exist?
        full_dir = output_dir.join('Scripts')
        full_dir.mkdir unless full_dir.exist?

        scripts_info_array = []
        scripts.each_with_index do |script, index|
            next if script.nil?
            scripts_info_array << { index: index, name: script[1] }
            script_file_path = full_dir.join("#{format('%03d', index)}.rb")
            print "#{Utils::ESCAPE}#{Utils::MAGENTA_COLOR}Serializing to #{Utils::RESET_COLOR}#{script_file_path}...\r" if $global_options[:verbose]
            script_file_path.write(Zlib::Inflate.inflate(script[2]).encode(universal_newline: true))
            print "#{Utils::ESCAPE}#{Utils::GREEN_COLOR}Serialized #{Utils::RESET_COLOR}#{script_file_path}\n" if $global_options[:verbose]
        end

        script_info_file_path = full_dir.join('Scripts_info.json')
        print "#{Utils::ESCAPE}#{Utils::MAGENTA_COLOR}Serializing to #{Utils::RESET_COLOR}#{script_info_file_path}\r" if $global_options[:verbose]
        Utils.object_json(scripts_info_array, script_info_file_path)
        print "#{Utils::ESCAPE}#{Utils::GREEN_COLOR}Serialized #{Utils::RESET_COLOR}#{script_info_file_path}\n" if $global_options[:verbose]
    end

    # 将 CommonEvents 对象数组序列化为分开的 JSON 文件
    #
    # @param commonevents [Array<Object>] 待转换的 CommonEvents 对象数组
    # @param output_dir [Pathname] 输出目录
    # @param complete [Boolean] 是否序列化所有内容
    # @param with_notes [Boolean] 是否包含备注
    #
    # @return [void]
    def R3EXS.commonevents_json(commonevents, output_dir, complete, with_notes)
        full_dir = output_dir.join('CommonEvents')

        if complete
            commonevents.each_with_index do |commonevent, index|
                commonevent_file_path = full_dir.join("#{format('CommonEvent_%05d', index)}.json")
                print "#{Utils::ESCAPE}#{Utils::MAGENTA_COLOR}Serializing to #{Utils::RESET_COLOR}#{commonevent_file_path}...\r" if $global_options[:verbose]
                Utils.object_json(commonevent, commonevent_file_path)
                print "#{Utils::ESCAPE}#{Utils::GREEN_COLOR}Serialized #{Utils::RESET_COLOR}#{commonevent_file_path}\n" if $global_options[:verbose]
            end
        else
            commonevents = Utils.rpg_r3exs(commonevents, 'CommonEvents', with_notes)
            commonevents.each do |commonevent|
                index                 = commonevent.index
                commonevent_file_path = full_dir.join("#{format('CommonEvent_%05d', index)}.json")
                print "#{Utils::ESCAPE}#{Utils::MAGENTA_COLOR}Serializing to #{Utils::RESET_COLOR}#{commonevent_file_path}...\r" if $global_options[:verbose]
                Utils.object_json(commonevent, commonevent_file_path)
                print "#{Utils::ESCAPE}#{Utils::GREEN_COLOR}Serialized #{Utils::RESET_COLOR}#{commonevent_file_path}\n" if $global_options[:verbose]
            end
        end
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
    def R3EXS.rvdata2_json(target_dir, output_dir, complete, with_scripts, with_notes)
        Utils.all_rvdata2_files(target_dir) do |object, file_basename, parent_relative_dir|
            if file_basename == 'Scripts'
                scripts_rb(object, output_dir.join(parent_relative_dir)) if with_scripts
            elsif file_basename == 'CommonEvents'
                commonevents_json(object, output_dir.join(parent_relative_dir), complete, with_notes)
            else
                file_path = output_dir.join(parent_relative_dir, "#{file_basename}.json")
                print "#{Utils::ESCAPE}#{Utils::MAGENTA_COLOR}Serializing to #{Utils::RESET_COLOR}#{file_path}...\r" if $global_options[:verbose]
                if complete
                    Utils.object_json(object, file_path)
                else
                    Utils.object_json(Utils.rpg_r3exs(object, file_basename, with_notes), file_path)
                end
                print "#{Utils::ESCAPE}#{Utils::GREEN_COLOR}Serialized #{Utils::RESET_COLOR}#{file_path}\n" if $global_options[:verbose]
            end
        end
    end

end
