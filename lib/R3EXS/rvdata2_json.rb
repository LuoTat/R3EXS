# frozen_string_literal: true

require 'zlib'
require_relative 'utils'
require_relative 'RGSS3_R3EXS'

module R3EXS

    # 将 Script 对象数组序列化为 Ruby 源码
    #
    # @param scripts [Array<Array>] 待转换的 Script 对象数组
    # @param output_dir [String] 输出目录
    # @return [void]
    def R3EXS.scripts_rb(scripts, output_dir)
        FileUtils.mkdir(output_dir) unless Dir.exist?(output_dir)
        full_dir = File.join(output_dir, 'Scripts')
        FileUtils.mkdir(full_dir) unless Dir.exist?(full_dir)

        scripts_info_array = []
        scripts.each_with_index do |script, index|
            next if script.nil?
            scripts_info_array << { index: index, name: script[1] }
            script_file_path = File.join(full_dir, "#{format('%03d', index)}.rb")
            print "#{Utils::ESCAPE}#{Utils::MAGENTA_COLOR}Serializing to #{Utils::RESET_COLOR}#{script_file_path}...\r" if $global_options[:verbose]
            File.write(script_file_path, Zlib::Inflate.inflate(script[2]).encode(universal_newline: true), mode: 'w')
        end

        script_info_file_path = File.join(full_dir, 'Scripts_info.json')
        print "#{Utils::ESCAPE}#{Utils::MAGENTA_COLOR}Serializing to #{Utils::RESET_COLOR}#{script_info_file_path}\r" if $global_options[:verbose]
        Utils.object_json(scripts_info_array, script_info_file_path)
    end

    # 将指定目录下的所有 rvdata2 文件序列化为 JSON 格式
    #
    # @param target_dir [String] 目标目录
    # @param output_dir [String] 输出目录
    # @param complete [Boolean] 是否序列化所有内容
    # @param with_scripts [Boolean] 是否包含脚本
    # @param with_notes [Boolean] 是否包含备注
    #
    # @raise [Rvdata2FileError] rvdata2 文件可能损坏
    # @raise [Rvdata2DirError] target_dir 不存在
    #
    # @return [void]
    def R3EXS.rvdata2_json(target_dir, output_dir, complete, with_scripts, with_notes)
        FileUtils.mkdir(output_dir) unless Dir.exist?(output_dir)
        Utils.all_rvdata2_files(target_dir) do |object, file_basename|

            if file_basename == 'Scripts'
                scripts_rb(object, output_dir) if with_scripts
                print "#{Utils::ESCAPE}#{Utils::GREEN_COLOR}Serialized #{Utils::RESET_COLOR}#{file_basename}\n" if $global_options[:verbose]
                next
            end

            file_path = File.join(output_dir, "#{file_basename}.json")
            print "#{Utils::ESCAPE}#{Utils::MAGENTA_COLOR}Serializing to #{Utils::RESET_COLOR}#{file_path}...\r" if $global_options[:verbose]
            if complete
                Utils.object_json(object, file_path)
            else
                Utils.object_json(Utils.rpg_r3exs(object, file_basename, with_notes), file_path)
            end
            print "#{Utils::ESCAPE}#{Utils::GREEN_COLOR}Serialized #{Utils::RESET_COLOR}#{file_basename}\n" if $global_options[:verbose]
        end
    end

end