# frozen_string_literal: true

require 'zlib'
require_relative 'ast'
require_relative 'utils'
require_relative 'RGSS3_R3EXS'

module R3EXS

    # 将 Ruby 源码中的字符串和符号提取出来
    #
    # @param target_dir [String] 目标目录
    # @param with_symbol [Boolean] 是否包含脚本中的符号
    #
    # @raise [ScriptsDirError] Scripts 目录不存在
    #
    # @return [Array<String>]
    def R3EXS.rb_ex_strings(target_dir, with_symbol)
        full_dir = File.join(target_dir, 'Scripts')
        Dir.exist?(full_dir) or raise ScriptsDirError.new(full_dir), "Scripts directory not found: #{full_dir}"

        strings           = []
        strings_extractor = StringsExtractor.new(strings, with_symbol)
        Dir.glob(File.join(full_dir, '*.rb')).each do |script_file_path|
            print "#{Utils::ESCAPE}#{Utils::MAGENTA_COLOR}Exreacting from #{Utils::RESET_COLOR}#{script_file_path}...\r" if $global_options[:verbose]

            strings_extractor.visit(Prism.parse_file(script_file_path).value)

            print "#{Utils::ESCAPE}#{Utils::GREEN_COLOR}Exreacted #{Utils::RESET_COLOR}#{script_file_path}\n" if $global_options[:verbose]
        end
        strings
    end

    # 将指定目录下的所有已经序列化为 R3EXS 后的 JOSN 文件中的字符串提取出来
    #
    # @param target_dir [String] 目标目录
    # @param output_dir [String] 输出目录
    # @param with_scripts [Boolean] 是否包含脚本
    # @param with_symbol [Boolean] 是否包含脚本中的符号
    # @param with_scripts_separate [Boolean] 是否将脚本提取的字符串单独存放
    #
    # @raise [R3EXSJsonFileError] json 文件不是 R3EXS 模块中的对象
    # @raise [JsonDirError] target_dir 不存在
    # @raise [ScriptsDirError] Scripts 目录不存在
    #
    # @return [void]
    def R3EXS.ex_strings(target_dir, output_dir, with_scripts, with_symbol, with_scripts_separate)
        FileUtils.mkdir(output_dir) unless Dir.exist?(output_dir)
        all_ex_strings = []

        Utils.all_json_files(target_dir, :R3EXS) do |object, file_basename|
            file_path = File.join(target_dir, "#{file_basename}.json")
            print "#{Utils::ESCAPE}#{Utils::MAGENTA_COLOR}Extracting from #{Utils::RESET_COLOR}#{file_path}...\r" if $global_options[:verbose]
            if object.is_a?(Array)
                object.each do |obj|
                    all_ex_strings.concat(obj.ex_strings)
                end
            else
                all_ex_strings.concat(object.ex_strings)
            end
            print "#{Utils::ESCAPE}#{Utils::GREEN_COLOR}Extracted #{Utils::RESET_COLOR}#{file_basename}\n" if $global_options[:verbose]
        end

        if with_scripts
            scripts_strings = rb_ex_strings(target_dir, with_symbol)
            if with_scripts_separate
                # 去除 nil 元素
                scripts_strings.compact!
                Utils.object_json(scripts_strings.each_with_object({}) { |item, h| h[item] = item }, File.join(output_dir, 'ManualTransFile_scripts.json'))
            else
                all_ex_strings.concat(scripts_strings)
            end
        end

        # 去除 nil 元素
        all_ex_strings.compact!
        Utils.object_json(all_ex_strings.each_with_object({}) { |item, h| h[item] = item }, File.join(output_dir, "ManualTransFile.json"))
    end

end