# frozen_string_literal: true
require 'oj'
require 'zlib'
require_relative 'RGSS3'
require_relative 'Utils'
require_relative 'RGSS3_R3EXS'

module R3EXS

    # 将 Script 对象数组序列化为 JSON 格式
    # @param scripts [Array<Array>] 待转换的 Script 对象数组
    # @param output_dir [String] 输出目录
    # @return [Void]
    def R3EXS.scripts_json(scripts, output_dir)
        full_path = File.join(output_dir, 'Scripts')
        FileUtils.mkdir(full_path) unless Dir.exist?(full_path)

        scripts_info_array = []
        scripts.each_with_index do |script, index|
            next if script.nil?
            scripts_info_array << { index: index, name: script[1] }
            script_file_dir = File.join(full_path, "#{format("%03d", index)}.rb")
            print "#{Utils::ESCAPE}#{Utils::MAGENTA_COLOR}Serializing to #{Utils::RESET_COLOR}#{script_file_dir}...\r" if $global_options[:verbose]
            File.write(script_file_dir, Zlib::Inflate.inflate(script[2]).encode(universal_newline: true), mode: 'w')
        end

        script_info_file_dir = File.join(full_path, "Scripts_info.json")
        print "#{Utils::ESCAPE}#{Utils::MAGENTA_COLOR}Serializing to #{Utils::RESET_COLOR}#{script_info_file_dir}\r" if $global_options[:verbose]
        Utils.object_json(scripts_info_array, script_info_file_dir)
    end

    # 将指定目录下的所有 rvdata2 文件序列化为 JSON 格式
    # @param target_dir [String] 目标目录
    # @param output_dir [String] 输出目录
    # @param complete [Boolean] 是否序列化所有内容
    # @param with_scripts [Boolean] 是否包含脚本
    # @param with_notes [Boolean] 是否包含备注
    # @return [Void]
    def R3EXS.rvdata2_json(target_dir, output_dir, complete, with_scripts, with_notes)
        FileUtils.mkdir(output_dir) unless Dir.exist?(output_dir)
        Utils.all_rvdata2_files(target_dir) do |object, file_basename|

            if file_basename == 'Scripts'
                scripts_json(object, output_dir) if with_scripts
                print "#{Utils::ESCAPE}#{Utils::GREEN_COLOR}Serialized #{Utils::RESET_COLOR}#{file_basename}\n" if $global_options[:verbose]
                next
            end

            file_dir = File.join(output_dir, "#{file_basename}.json")
            print "#{Utils::ESCAPE}#{Utils::MAGENTA_COLOR}Serializing to #{Utils::RESET_COLOR}#{file_dir}...\r" if $global_options[:verbose]
            if complete
                Utils.object_json(object, file_dir)
            else
                Utils.object_json(Utils.rpg_r3exs(object, file_basename, with_notes), file_dir)
            end
            print "#{Utils::ESCAPE}#{Utils::GREEN_COLOR}Serialized #{Utils::RESET_COLOR}#{file_basename}\n" if $global_options[:verbose]
        end
    end

end