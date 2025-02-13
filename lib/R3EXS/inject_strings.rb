# frozen_string_literal: true

require 'zlib'
require_relative 'ast'
require_relative 'utils'
require_relative 'RGSS3_R3EXS'

module R3EXS

    # 将 Ruby 源码中的字符串和符号替换为指定的字符串
    #
    # @param target_dir [String] 目标目录
    # @param output_dir [String] 输出目录
    # @param hash [Hash]
    #
    # @raise [ScriptsDirError] Scripts 目录不存在
    #
    # @return [void]
    def R3EXS.rb_in_strings(target_dir, output_dir, hash)
        target_full_dir = File.join(target_dir, 'Scripts')
        output_full_dir = File.join(output_dir, 'Scripts')
        FileUtils.mkdir(output_full_dir) unless Dir.exist?(output_full_dir)
        Dir.exist?(target_full_dir) or raise ScriptsDirError.new(target_full_dir), "Scripts directory not found: #{target_full_dir}"

        Dir.glob(File.join(target_full_dir, "*.rb")).each do |script_file_path|
            output_script_file_dir = File.join(output_full_dir, File.basename(script_file_path))
            print "#{Utils::ESCAPE}#{Utils::MAGENTA_COLOR}Injecting to #{Utils::RESET_COLOR}#{output_script_file_dir}...\r" if $global_options[:verbose]

            File.write(output_script_file_dir, StringsInjector.new(hash).rewrite(script_file_path, Prism.parse_file(script_file_path).value), mode: 'w')

            print "#{Utils::ESCAPE}#{Utils::GREEN_COLOR}Injected #{Utils::RESET_COLOR}#{output_script_file_dir}\n" if $global_options[:verbose]
        end
    end

    # 将指定目录下的所有已经序列化为 R3EXS 后的 JOSN 文件按照 ManualTransFile.json 翻译注入
    #
    # @param target_dir [String] 目标目录
    # @param output_dir [String] 输出目录
    # @param manualtransfile_path [String] ManualTransFile.json 文件路径
    # @param with_scripts [Boolean] 是否包含脚本
    #
    # @raise [R3EXSJsonFileError] json 文件不是 R3EXS 模块中的对象
    # @raise [JsonDirError] target_dir 不存在
    # @raise [ScriptsDirError] Scripts 目录不存在
    # @raise [ManualTransFilePath] ManualTransFile.json 不存在
    #
    # @return [void]
    def R3EXS.in_strings(target_dir, output_dir, manualtransfile_path, with_scripts)
        FileUtils.mkdir(output_dir) unless Dir.exist?(output_dir)
        File.exist?(manualtransfile_path) or raise ManualTransFilePathError.new(manualtransfile_path), "ManualTransFile.json not found: #{manualtransfile_path}"

        manual_trans_hash = Oj.load_file(manualtransfile_path)

        Utils.all_json_files(target_dir, :R3EXS) do |object, file_basename|
            file_path = File.join(output_dir, "#{file_basename}.json")
            print "#{Utils::ESCAPE}#{Utils::MAGENTA_COLOR}Injecting to #{Utils::RESET_COLOR}#{file_path}...\r" if $global_options[:verbose]
            if object.is_a?(Array)
                object.each do |obj|
                    obj.in_strings(manual_trans_hash)
                end
            else
                object.in_strings(manual_trans_hash)
            end
            Utils.object_json(object, file_path)
            print "#{Utils::ESCAPE}#{Utils::GREEN_COLOR}Injected #{Utils::RESET_COLOR}#{file_basename}\n" if $global_options[:verbose]
        end

        if with_scripts
            rb_in_strings(target_dir, output_dir, manual_trans_hash)
        end
    end

end