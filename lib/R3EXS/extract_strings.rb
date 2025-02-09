# frozen_string_literal: true
require 'oj'
require 'zlib'
require_relative 'ast'
require_relative 'RGSS3'
require_relative 'Utils'
require_relative 'RGSS3_R3EXS'

module R3EXS

    # 将 *.rb 源码中的字符串和符号提取出来
    # @param target_dir [String] 目标目录
    # @param with_symbol [Boolean] 是否包含脚本中的符号
    # @return [Array<String>] 提取出的字符串数组
    def R3EXS.scripts_ex_strings(target_dir, with_symbol)
        full_path = File.join(target_dir, 'Scripts')
        Dir.exist?(full_path) or raise Errno::ENOENT, "Scripts directory not found: #{full_path}"

        strings = []
        Dir.glob(File.join(full_path, "*.rb")).each do |script_file_dir|
            print "#{Utils::ESCAPE}#{Utils::MAGENTA_COLOR}Exreacting from #{Utils::RESET_COLOR}#{script_file_dir}...\r" if $global_options[:verbose]

            StringsExtractor.new(strings, with_symbol).visit(Prism.parse_file(script_file_dir).value)

            print "#{Utils::ESCAPE}#{Utils::GREEN_COLOR}Exreacted #{Utils::RESET_COLOR}#{script_file_dir}\n" if $global_options[:verbose]
        end
        strings.uniq!
        Utils.object_json(strings, File.join("C:/Users/LuoTat/Desktop/R3EXS", "ScriptsTransFile.json"))
        strings
    end

    # 将指定目录下的所有已经序列化为 R3EXS 后的 JOSN 文件中的字符串提取出来
    # @param target_dir [String] 目标目录
    # @param output_dir [String] 输出目录
    # @param with_scripts [Boolean] 是否包含脚本
    # @param with_symbol [Boolean] 是否包含脚本中的符号
    # @return [Void]
    def R3EXS.ex_strings(target_dir, output_dir, with_scripts, with_symbol)
        FileUtils.mkdir(output_dir) unless Dir.exist?(output_dir)
        all_ex_strings = []
        Utils.all_json_files(target_dir, :R3EXS) do |object, file_basename|
            file_dir = File.join(target_dir, "#{file_basename}.json")
            print "#{Utils::ESCAPE}#{Utils::MAGENTA_COLOR}Extracting from #{Utils::RESET_COLOR}#{file_dir}...\r" if $global_options[:verbose]
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
            begin
                all_ex_strings.concat(scripts_ex_strings(target_dir, with_symbol))
            rescue Errno::ENOENT => e
                $stderr.puts "#{Utils::RED_COLOR}#{e.message}#{Utils::RESET_COLOR}"
                $stderr.puts "You are supposed to use '#{Utils::GREEN_COLOR}-s#{Utils::RESET_COLOR}' or '#{Utils::GREEN_COLOR}--scripts#{Utils::RESET_COLOR}' to enable serialization of Scripts in #{Utils::GREEN_COLOR}rvdata2_json#{Utils::RESET_COLOR} subcommand"
                $stderr.puts "For more information, please enter '#{Utils::GREEN_COLOR}R3EXS help rvdata2_json#{Utils::RESET_COLOR}'"
            end
        end

        # 去除 nil 元素
        all_ex_strings.compact!
        Utils.object_json(all_ex_strings.each_with_object({}) { |item, h| h[item] = item }, File.join(output_dir, "ManualTransFile.json"))
    end

end