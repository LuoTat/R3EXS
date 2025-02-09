# frozen_string_literal: true
require 'oj'
require 'zlib'
require_relative 'ast'
require_relative 'RGSS3'
require_relative 'Utils'
require_relative 'RGSS3_R3EXS'

module R3EXS

    # 将 *.rb 源码中的字符串和符号替换为指定的字符串
    # @param target_dir [String] 目标目录
    # @param output_dir [String] 输出目录
    # @param hash [Hash]
    # @return [Void]
    def R3EXS.scripts_in_strings(target_dir, output_dir, hash)
        target_full_path = File.join(target_dir, 'Scripts')
        output_full_path = File.join(output_dir, 'Scripts')
        FileUtils.mkdir(output_full_path) unless Dir.exist?(output_full_path)
        Dir.exist?(target_full_path) or raise Errno::ENOENT, "Scripts directory not found: #{target_full_path}"

        Dir.glob(File.join(target_full_path, "*.rb")).each do |script_file_dir|
            output_script_file_dir = File.join(output_full_path, File.basename(script_file_dir))
            print "#{Utils::ESCAPE}#{Utils::MAGENTA_COLOR}Injecting to #{Utils::RESET_COLOR}#{output_script_file_dir}...\r" if $global_options[:verbose]

            File.write(output_script_file_dir, StringsInjector.new(hash).rewrite(script_file_dir, Prism.parse_file(script_file_dir).value), mode: 'w')

            print "#{Utils::ESCAPE}#{Utils::GREEN_COLOR}Injected #{Utils::RESET_COLOR}#{output_script_file_dir}\n" if $global_options[:verbose]
        end
    end

    # 将指定目录下的所有已经序列化为 R3EXS 后的 JOSN 文件中的字符串按照 ManualTransFile.json 翻译注入
    # @param target_dir [String] 目标目录
    # @param output_dir [String] 输出目录
    # @param manualtransfile_dir [String] ManualTransFile.json 文件路径
    # @param with_scripts [Boolean] 是否包含脚本
    # @return [Void]
    def R3EXS.in_strings(target_dir, output_dir, manualtransfile_dir, with_scripts)
        FileUtils.mkdir(output_dir) unless Dir.exist?(output_dir)
        unless File.exist?(manualtransfile_dir)
            $stderr.puts "#{Utils::RED_COLOR}ManualTransFile.json not found: #{manualtransfile_dir}#{Utils::RESET_COLOR}"
            $stderr.puts "You are supposed to use #{Utils::GREEN_COLOR}ex_strings#{Utils::RESET_COLOR} subcommand"
            $stderr.puts "For more information, please enter '#{Utils::GREEN_COLOR}R3EXS help ex_strings#{Utils::RESET_COLOR}'"
        end
        manual_trans_hash = Oj.load_file(manualtransfile_dir)

        Utils.all_json_files(target_dir, :R3EXS) do |object, file_basename|
            file_dir = File.join(output_dir, "#{file_basename}.json")
            print "#{Utils::ESCAPE}#{Utils::MAGENTA_COLOR}Injecting to #{Utils::RESET_COLOR}#{file_dir}...\r" if $global_options[:verbose]
            if object.is_a?(Array)
                object.each do |obj|
                    obj.in_strings(manual_trans_hash)
                end
            else
                object.in_strings(manual_trans_hash)
            end
            Utils.object_json(object, file_dir)
            print "#{Utils::ESCAPE}#{Utils::GREEN_COLOR}Injected #{Utils::RESET_COLOR}#{file_basename}\n" if $global_options[:verbose]
        end

        if with_scripts
            begin
                scripts_in_strings(target_dir, output_dir, manual_trans_hash)
            rescue Errno::ENOENT => e
                $stderr.puts "#{Utils::RED_COLOR}#{e.message}#{Utils::RESET_COLOR}"
                $stderr.puts "You are supposed to use '#{Utils::GREEN_COLOR}-s#{Utils::RESET_COLOR}' or '#{Utils::GREEN_COLOR}--scripts#{Utils::RESET_COLOR}' to enable serialization of Scripts in #{Utils::GREEN_COLOR}rvdata2_json#{Utils::RESET_COLOR} subcommand"
                $stderr.puts "For more information, please enter '#{Utils::GREEN_COLOR}R3EXS help rvdata2_json#{Utils::RESET_COLOR}'"
            end
        end
    end

end