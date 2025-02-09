# frozen_string_literal: true
require 'oj'
require 'zlib'
require_relative 'RGSS3'
require_relative 'Utils'

module R3EXS

    # 将 *.rb 文件读取压缩后序列化到输出目录
    # @param target_dir [String] 目标目录
    # @param output_dir [String] 输出目录
    # @return [Void]
    def R3EXS.json_scripts(target_dir, output_dir)
        scripts_array = []
        full_path = File.join(target_dir, 'Scripts')
        script_info_file_dir = File.join(full_path, "Scripts_info.json")

        Dir.exist?(full_path) or raise Errno::ENOENT, "Scripts directory not found: #{full_path}"
        File.exist?(script_info_file_dir) or raise Errno::ENOENT, "Scripts_info.json not found: #{script_info_file_dir}"

        print "#{Utils::ESCAPE}#{Utils::YELLOW_COLOR}Reading from #{Utils::RESET_COLOR}#{script_info_file_dir}...\r" if $global_options[:verbose]
        scripts_info_array = Oj.load_file(script_info_file_dir)

        scripts_info_array.each do |script_info|
            index = script_info[:index]
            script_file_dir = File.join(full_path, "#{format("%03d", index)}.rb")
            print "#{Utils::ESCAPE}#{Utils::YELLOW_COLOR}Reading from #{Utils::RESET_COLOR}#{script_file_dir}...\r" if $global_options[:verbose]
            scripts_array << [114514, script_info[:name], Zlib::Deflate.deflate(File.read(script_file_dir, mode: "r"))]
        end
        Utils.object_rvdata2(scripts_array, File.join(output_dir, "Scripts.rvdata2"))
    end

    # 将指定目录下的所有JSON文件转换为 rvdata2 文件
    # @param [String] target_dir 目标目录
    # @param [String] output_dir 输出目录
    # @param [String] original_dir 原始 rvdata2 文件目录
    # @param [Boolean] complete 是否完全转换
    # @param [Boolean] with_scripts 是否转换Scripts
    # @return [Void]
    def R3EXS.json_rvdata2(target_dir, output_dir, original_dir, complete, with_scripts)
        FileUtils.mkdir(output_dir) unless Dir.exist?(output_dir)

        if complete
            Utils.all_json_files(target_dir, :RPG) do |object, file_basename|
                file_dir = File.join(output_dir, "#{file_basename}.rvdata2")
                print "#{Utils::ESCAPE}#{Utils::MAGENTA_COLOR}Serializing to #{Utils::RESET_COLOR}#{file_dir}...\n" if $global_options[:verbose]
                Utils.object_rvdata2(object, file_dir)
                print "#{Utils::ESCAPE}#{Utils::GREEN_COLOR}Serialized #{Utils::RESET_COLOR}#{file_basename}\n" if $global_options[:verbose]
            end
        else
            Utils.all_json_files(target_dir, :R3EXS) do |object, file_basename|
                # 检查 original_dir 是否存在
                Dir.exist?(original_dir) or raise Errno::ENOENT "Original directory not found: #{original_dir}"

                original_file_dir = File.join(original_dir, file_basename + '.rvdata2')
                print "#{Utils::ESCAPE}#{Utils::BLUE_COLOR}Reading and Deserializing #{Utils::RESET_COLOR}#{original_file_dir}...\r" if $global_options[:verbose]
                original_object = File.open(original_file_dir, 'rb') { |file| Marshal.load(file) }

                begin
                    # 这里的类型检查要用紧凑模式，因为 rvdata2 文件中可能存在 nil 元素，必须忽略
                    Utils.check_type(original_object, file_basename, true, :RPG)
                rescue TypeError => e
                    $stderr.puts "#{Utils::RED_COLOR}#{e.message}#{Utils::RESET_COLOR}"
                    $stderr.puts "The file #{Utils::GREEN_COLOR}#{file_basename}.rvdata2#{Utils::RESET_COLOR} is not a valid rvdata2 file"
                    next
                end

                file_dir = File.join(output_dir, "#{file_basename}.rvdata2")
                print "#{Utils::ESCAPE}#{Utils::MAGENTA_COLOR}Serializing to #{Utils::RESET_COLOR}#{file_dir}...\n" if $global_options[:verbose]

                # 根据是否为数组进行不同的处理
                if object.is_a?(Array)
                    object.each do |obj|
                        obj.inject_to(original_object[obj.index])
                    end
                else
                    object.inject_to(original_object)
                end
                Utils.object_rvdata2(original_object, file_dir)
                print "#{Utils::ESCAPE}#{Utils::GREEN_COLOR}Serialized #{Utils::RESET_COLOR}#{file_basename}\n" if $global_options[:verbose]
            end
        end

        if with_scripts
            print "#{Utils::ESCAPE}#{Utils::MAGENTA_COLOR}Serializing to #{Utils::RESET_COLOR}#{File.join(output_dir, "Scripts.rvdata2")}...\r" if $global_options[:verbose]
            begin
                json_scripts(target_dir, output_dir)
                print "#{Utils::ESCAPE}#{Utils::GREEN_COLOR}Serialized #{Utils::RESET_COLOR}Scripts\n" if $global_options[:verbose]
            rescue Errno::ENOENT => e
                $stderr.puts "#{Utils::RED_COLOR}#{e.message}#{Utils::RESET_COLOR}"
                $stderr.puts "You are supposed to use '#{Utils::GREEN_COLOR}-s#{Utils::RESET_COLOR}' or '#{Utils::GREEN_COLOR}--scripts#{Utils::RESET_COLOR}' to enable serialization of Scripts in #{Utils::GREEN_COLOR}rvdata2_json#{Utils::RESET_COLOR} subcommand"
                $stderr.puts "For more information, please enter '#{Utils::GREEN_COLOR}R3EXS help rvdata2_json#{Utils::RESET_COLOR}'"
            end
        end
    end

end