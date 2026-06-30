# frozen_string_literal: true

require 'oj'
require_relative 'RGSS3'
require_relative 'RGSS3_R3EXS'
require_relative 'logger'

module R3EXS
  # 工具模块
  # 主要用来提供一些读取，写入，转换等功能
  module Utils
    # 用来匹配读取的文件名到对应的R3EXS的类
    FILE_BASENAME_TO_CLASS_R3EXS = {
      /\AActors\z/ => R3EXS::Actor,
      /\AAnimations\z/ => R3EXS::Animation,
      /\AArmors\z/ => R3EXS::Armor,
      /\AClasses\z/ => R3EXS::Class,
      /\ACommonEvents\z/ => R3EXS::CommonEvent,
      /\AEnemies\z/ => R3EXS::Enemy,
      /\AItems\z/ => R3EXS::Item,
      /\AMap\d{3}\z/ => R3EXS::Map,
      /\AMapInfos\z/ => R3EXS::MapInfo,
      /\AScripts\z/ => Array,
      /\ASkills\z/ => R3EXS::Skill,
      /\AStates\z/ => R3EXS::State,
      /\ASystem\z/ => R3EXS::System,
      /\ATilesets\z/ => R3EXS::Tileset,
      /\ATroops\z/ => R3EXS::Troop,
      /\AWeapons\z/ => R3EXS::Weapon
    }.freeze

    # 用来匹配读取的文件名到对应的RPG的类
    FILE_BASENAME_TO_CLASS_RPG = {
      /\AActors\z/ => RPG::Actor,
      /\AAnimations\z/ => RPG::Animation,
      /\AArmors\z/ => RPG::Armor,
      /\AClasses\z/ => RPG::Class,
      /\ACommonEvents\z/ => RPG::CommonEvent,
      /\AEnemies\z/ => RPG::Enemy,
      /\AItems\z/ => RPG::Item,
      /\AMap\d{3}\z/ => RPG::Map,
      /\AMapInfos\z/ => RPG::MapInfo,
      /\AScripts\z/ => Array,
      /\ASkills\z/ => RPG::Skill,
      /\AStates\z/ => RPG::State,
      /\ASystem\z/ => RPG::System,
      /\ATilesets\z/ => RPG::Tileset,
      /\ATroops\z/ => RPG::Troop,
      /\AWeapons\z/ => RPG::Weapon
    }.freeze

    # 读取 target_dir 下的所有 rvdata2 文件，将其反序列化为对象，并调用 block
    #
    # @note 注意传入 block 的 object
    #       - 如果 object 是数组或哈希，则其中可能存在 nil 元素
    #       - 如果 object 是单独一个对象，则不可能为 nil
    #
    # @param target_dir [Pathname] 目标目录
    #
    # @yieldparam object [Object] rvdata2 文件反序列化后的对象
    # @yieldparam klass [::Class] rvdata2 文件所对应 R3EXS 模块的类
    # @yieldparam file_basename [Pathname] 文件名（不包含扩展名）
    # @yieldparam relative_dir [Pathname] 文件相对 target_dir 的路径
    # @yieldreturn [void]
    #
    # @raise [Rvdata2DirError] target_dir 不存在
    #
    # @return [void]
    def self.all_rvdata2_files(target_dir)
      # 检查 target_dir 目录是否存在
      target_dir.exist? && target_dir.directory? or raise Rvdata2DirError, "rvdata2 directory not found: #{target_dir}"

      # 递归获取 target_dir 下的所有 *.rvdata2 文件
      target_dir.glob('**/*.rvdata2').each do |file_path|
        file_basename = file_path.basename('.rvdata2')
        # 获取文件名所对应的类，若无法匹配则跳过该文件
        klass = name_class(file_basename, :R3EXS)
        next if klass.nil?

        object = Marshal.load(file_path.binread, freeze: true)
        Logger.debug("Deserialize #{file_path}")
        yield object, klass, file_basename, file_path
      end
    end

    # 读取 target_dir 下的所有常规 JSON 文件，将其反序列化为对象，并调用 block
    #
    # @note 注意传入 block 的 object
    #       - 在 module_name 为 RPG 时，如果 object 是数组或哈希，则其中可能存在 nil 元素。如果 object 是单独一个对象，则不可能为 nil
    #       - 在 module_name 为 R3EXS 时，object 不会为 nil
    #
    # @param target_dir [Pathname] 目标目录
    # @param module_name [Symbol] 模块名
    #
    # @yieldparam object [Object] JSON 文件反序列化后的对象
    # @yieldparam file_path [Pathname] 文件路径
    # @yieldreturn [void]
    #
    # @raise [JsonDirError] target_dir 不存在
    # @raise [RPGJsonFileError] json 文件不是 RPG 模块中的对象
    # @raise [R3EXSJsonFileError] json 文件不是 R3EXS 模块中的对象
    # @raise [ModuleNameError] module_name 不是 :RPG 或 :R3EXS
    #
    # @return [void]
    def self.all_regular_json_files(target_dir, module_name)
      # 检查 target_dir 目录是否存在
      target_dir.exist? && target_dir.directory? or raise JsonDirError, "JSON directory not found: #{target_dir}"

      # 递归获取 target_dir 下的所有 *.json 文件
      target_dir.glob('**/*.json').each do |file_path|
        file_basename = file_path.basename('.json')
        # 获取文件名所对应的类，若无法匹配则跳过该文件
        klass = name_class(file_basename, module_name)
        next if klass.nil?

        object = Oj.load_file(file_path.to_s)
        Logger.debug("Deserialize #{file_path}")
        case module_name
        when :RPG
          # 因为这是从 rvdata2 文件直接全部序列化后的 JSON 文件中读取的 object，其中可能存在 nil 元素
          begin
            check_type(object, klass, true)
          rescue TypeError
            raise RPGJsonFileError, "Invalid RPG JSON file: #{file_path}"
          end
        when :R3EXS
          # 因为这是从 R3EXS 模块的类序列化后的 JSON 文件中读取的 object，程序设计中不应该存在 nil 元素
          begin
            check_type(object, klass, false)
          rescue TypeError
            raise R3EXSJsonFileError, "Invalid R3EXS JSON file: #{file_path}"
          end
        else
          raise ModuleNameError, "Invalid module name: #{module_name}"
        end
        yield object, file_path
      end
    end

    # 读取 target_dir 下的所有 CommonEvent JSON 文件，将其反序列化为对象数组，并调用 block
    #
    # @note 注意传入 block 的 object
    #       - 在 module_name 为 RPG 时，object 可能存在 nil 元素
    #       - 在 module_name 为 R3EXS 时，object 不可能存在 nil 元素
    #
    # @param target_dir [Pathname] 目标目录
    # @param module_name [Symbol] 模块名
    #
    # @yieldparam commonevents [Array<RPG::CommonEvent, R3EXS::CommonEvent>] CommonEvent JSON 文件反序列化后的数组
    # @yieldparam commonevents_paths [Array<Pathname>] CommonEvent JSON 文件路径数组
    # @yieldparam rvdata2_file_path [Pathname] 所属 CommonEvents.rvdata2 的路径
    # @yieldreturn [void]
    #
    # @raise [JsonDirError] target_dir 不存在
    # @raise [RPGJsonFileError] json 文件不是 RPG 模块中的对象
    # @raise [R3EXSJsonFileError] json 文件不是 R3EXS 模块中的对象
    # @raise [ModuleNameError] module_name 不是 :RPG 或 :R3EXS
    #
    # @return [void]
    def self.all_commonevent_json_files(target_dir, module_name)
      # 检查 target_dir 目录是否存在
      target_dir.exist? && target_dir.directory? or raise JsonDirError, "JSON directory not found: #{target_dir}"

      # 用两个Hash来存储每一个父目录下的所有的 CommonEvent_\d{5}.json 文件反序列化后的对象数组以及路径数组
      # Hash 的键是父目录的路径，值是一个数组，存储该目录下的所有 CommonEvent_\d{5}.json 文件的反序列化后的对象数组以及其路径数组
      commonevents_hash = Hash.new { |h, k| h[k] = [] }
      commonevents_path_hash = Hash.new { |h, k| h[k] = [] }

      # 递归获取 target_dir 下的所有 CommonEvent_\d{5}.json 文件
      target_dir.glob('**/CommonEvent_[0-9][0-9][0-9][0-9][0-9].json').each do |file_path|
        object = Oj.load_file(file_path.to_s)
        case module_name
        when :RPG
          # 因为这是从 rvdata2 文件直接全部序列化后的 JSON 文件中读取的 object，其中可能存在 nil 元素
          begin
            check_type(object, RPG::CommonEvent, true)
          rescue TypeError
            raise RPGJsonFileError, 'Invalid RPG CommonEvents JSON file'
          end
        when :R3EXS
          # 因为这是从 R3EXS 模块的类序列化后的 JSON 文件中读取的 object，程序设计中不应该存在 nil 元素
          begin
            check_type(object, R3EXS::CommonEvent, false)
          rescue TypeError
            raise R3EXSJsonFileError, 'Invalid R3EXS CommonEvents JSON file'
          end
        else
          raise ModuleNameError, "Invalid module name: #{module_name}"
        end
        Logger.debug("Deserialize #{file_path}")
        parent_dir = file_path.parent
        commonevents_hash[parent_dir] << object
        commonevents_path_hash[parent_dir] << file_path
      end

      # 遍历每一个父目录的路径
      commonevents_hash.each_key do |parent_dir|
        commonevents = commonevents_hash[parent_dir]
        commonevents_paths = commonevents_path_hash[parent_dir]
        yield commonevents, commonevents_paths, parent_dir.parent.join('CommonEvents.rvdata2')
      end
    end

    # 读取 target_dir 下的所有 Ruby 源码文件，并调用 block
    #
    # @param target_dir [Pathname] 目标目录
    #
    # @yieldparam scripts [Array<String>] Ruby 源码文件数组
    # @yieldparam scripts_info [Array<Hash>] Scripts_info.json 反序列化后的对象
    # @yieldparam scripts_paths [Array<Pathname>] Ruby 源码文件名路径数组
    # @yieldparam script_info_file_path [Pathname] Scripts_info.json 文件路径
    # @yieldparam rvdata2_file_path [Pathname] 所属 Scripts.rvdata2 的路径
    # @yieldreturn [void]
    #
    # @raise [JsonDirError] target_dir 不存在
    # @raise [ScriptsInfoPathError] Scripts_info.json 不存在
    #
    # @return [void]
    def self.all_rb_files(target_dir)
      # 检查 target_dir 目录是否存在
      target_dir.exist? && target_dir.directory? or raise JsonDirError, "JSON directory not found: #{target_dir}"

      # 用两个Hash来存储每一个父目录下的所有的 Script_\d{3}.rb 文件反序列化后的对象数组以及路径数组
      # Hash 的键是父目录的路径，值是一个数组，存储该目录下的所有 Script_\d{3}.rb 文件的反序列化后的对象数组以及其路径数组
      scripts_hash = Hash.new { |h, k| h[k] = [] }
      scripts_path_hash = Hash.new { |h, k| h[k] = [] }

      # 递归获取 target_dir 下的所有 Script_\d{3}.rb 文件
      target_dir.glob('**/Script_[0-9][0-9][0-9].rb').each do |file_path|
        object = file_path.read
        Logger.debug("Read        #{file_path}")
        parent_dir = file_path.parent
        scripts_hash[parent_dir] << object
        scripts_path_hash[parent_dir] << file_path
      end

      # 遍历每一个父目录的路径
      scripts_hash.each_key do |parent_dir|
        script_info_file_path = parent_dir.join('Scripts_info.json')
        script_info_file_path.exist? or raise ScriptsInfoPathError, "Scripts_info.json not found: #{script_info_file_path}"

        scripts = scripts_hash[parent_dir]
        script_info = Oj.load_file(script_info_file_path.to_s)
        scripts_paths = scripts_path_hash[parent_dir]
        yield scripts, script_info, scripts_paths, script_info_file_path, parent_dir.parent.join('Scripts.rvdata2')
      end
    end

    # 检查 object 的类型是否正确属于 klass
    #
    # @param object [Object] 待检查的对象
    # @param klass [::Class] 期望的类
    # @param has_nil [Boolean] 是否允许 object 中存在 nil 元素
    #
    # @raise [TypeError] object 的类型不属于期望的类
    #
    # @return [void]
    def self.check_type(object, klass, has_nil)
      if object.is_a?(Array)
        items = has_nil ? object.compact : object
        items.all? { |item| item.is_a?(klass) } or raise TypeError, "Object isn't an Array<#{klass}>"
      elsif object.is_a?(Hash)
        values = has_nil ? object.compact.values : object.values
        values.all? { |item| item.is_a?(klass) } or raise TypeError, "Object isn't a Hash<#{klass}>"
      elsif !object.nil? # 需考虑 object 为 nil的情况
        object.is_a?(klass) or raise TypeError, "Object isn't a #{klass}"
      end
    end

    # 根据 file_basename 和 module_name 获取对应的类
    #
    # @param file_basename [Pathname] 文件名（不包含扩展名）
    # @param module_name [Symbol] 模块名
    #
    # @raise [ModuleNameError] module_name 不是 :RPG 或 :R3EXS
    #
    # @return [::Class, nil] 若 file_basename 无法匹配则返回 nil
    def self.name_class(file_basename, module_name)
      table =
        case module_name
        when :RPG
          FILE_BASENAME_TO_CLASS_RPG
        when :R3EXS
          FILE_BASENAME_TO_CLASS_R3EXS
        else
          raise ModuleNameError, "Invalid module name: #{module_name}"
        end
      table.find { |pattern, _| file_basename.to_s =~ pattern }&.last
    end

    # 将 R3EXS 对象中的字符串注入 RPG 对象中
    #
    # @param object [Object] 待转化的 R3EXS 对象
    #
    # @return [Object]
    def self.r3exs_rpg(r3exs_obj, rpg_obj)
      if r3exs_obj.is_a?(Array)
        r3exs_obj.each { |obj| obj.inject_to(rpg_obj[obj.index]) }
      elsif r3exs_obj.is_a?(Hash) # 只有 RPG::MapInfo 是 Hash，且 key 为整数
        r3exs_obj.each { |key, obj| obj.inject_to(rpg_obj[key]) }
      else
        # 只有 RPG::Map 和 RPG::System 是单独一个对象，且不可能为 nil
        r3exs_obj.inject_to(rpg_obj)
      end
    end

    # 将 RPG 对象转化为 R3EXS 对象
    #
    # @param object [Object] 待转化的 RPG 对象
    # @param klass [::Class] 对应的 R3EXS 模块中的类
    #
    # @return [Object]
    def self.rpg_r3exs(object, klass)
      if object.is_a?(Array)
        temp = []
        object.each_with_index do |obj, index|
          next if obj.nil?

          obj_r3exs = klass.new(obj, index)
          temp << obj_r3exs unless obj_r3exs.empty?
        end
      elsif object.is_a?(Hash) # 只有 RPG::MapInfo 是 Hash，且 key 为整数
        temp = {}
        object.each do |key, obj|
          next if obj.nil?

          obj_r3exs = klass.new(obj)
          temp[key] = obj_r3exs unless obj_r3exs.empty?
        end
      else
        # 只有 RPG::Map 和 RPG::System 是单独一个对象，且不可能为 nil
        temp = klass.new(object)
      end
      temp
    end

    # 提取 R3EXS 对象中的字符串
    #
    # @param object [Object] 待注入的 R3EXS 对象
    # @param manual_trans_hash[Hash{String => String}] 翻译结果
    #
    # @return [Array<String>]
    def self.in_r3exs(object, manual_trans_hash)
      if object.is_a?(Array)
        object.each { |obj| obj.in_strings(manual_trans_hash) }
      elsif object.is_a?(Hash)
        object.each_value { |obj| obj.in_strings(manual_trans_hash) }
      else
        object.in_strings(manual_trans_hash)
      end
    end

    # 提取 R3EXS 对象中的字符串
    #
    # @param object [Object] 待提取的 R3EXS 对象
    #
    # @return [Array<String>]
    def self.ex_r3exs(object)
      ex_strings = []
      if object.is_a?(Array)
        object.each { |obj| ex_strings.concat(obj.ex_strings) }
      elsif object.is_a?(Hash)
        object.each_value { |obj| ex_strings.concat(obj.ex_strings) }
      else
        ex_strings.concat(object.ex_strings)
      end
      ex_strings
    end

    # 将 script 序列化为 rb 文件
    #
    # @param script [String] rb 源码
    # @param file_path [Pathname] 输出文件路径
    #
    # @return [void]
    def self.script_rb(script, file_path)
      file_path.parent.mkpath unless file_path.parent.exist?
      file_path.write(script.encode(universal_newline: true))
    end

    # 将压缩 script 序列化为 rb 文件
    #
    # @param script [String] rb 压缩源码
    # @param file_path [Pathname] 输出文件路径
    #
    # @return [void]
    def self.script_rb_compressing(script, file_path)
      script_rb(Zlib::Inflate.inflate(script), file_path)
    end

    # 将 object 序列化为 json 文件
    #
    # @param object [Object] 待序列化的对象
    # @param file_path [Pathname] 输出文件路径
    #
    # @return [void]
    def self.object_json(object, file_path)
      file_path.parent.mkpath unless file_path.parent.exist?
      file_path.write(Oj.dump(object, indent: 2))
    end

    # 将 object 序列化为 rvdata2 文件
    #
    # @param object [Object] 待序列化的对象
    # @param file_path [Pathname] 输出文件路径
    #
    # @return [void]
    def self.object_rvdata2(object, file_path)
      file_path.parent.mkpath unless file_path.parent.exist?
      file_path.binwrite(Marshal.dump(object))
    end
  end
end

class String
  unless method_defined?(:blank?) && ' '.blank?
    # Checks whether a string is blank. A string is considered blank if it
    # is either empty or contains only whitespace characters.
    #
    # @return [Boolean] true is the string is blank, false otherwise
    #
    # @example
    #   ''.blank?       #=> true
    #   '    '.blank?   #=> true
    #   '  test'.blank? #=> false
    def blank?
      empty? || lstrip.empty?
    end
  end
end
