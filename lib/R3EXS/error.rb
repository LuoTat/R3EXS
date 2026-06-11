# frozen_string_literal: true

module R3EXS
  # 用来处理 RPG 模块下的类型错误的异常
  class RPGTypeError < TypeError
    # 引发异常的类
    #
    # @return [Object]
    attr_reader :obj

    # 初始化 RPGTypeError
    #
    # @param msg [String] 异常信息
    # @param obj [Object] 引发异常的类
    #
    # @return [RPGTypeError]
    def initialize(obj, msg = nil)
      super(msg)
      @obj = obj
    end
  end

  # 用来处理 R3EXS 模块下的类型错误的异常
  class R3EXSTypeError < TypeError
    # 引发异常的类型
    #
    # @return [Object]
    attr_reader :obj

    # 初始化 R3EXSTypeError
    #
    # @param msg [String] 异常信息
    # @param obj [Object] 引发异常的的类型
    #
    # @return [R3EXSTypeError]
    def initialize(obj, msg = nil)
      super(msg)
      @obj = obj
    end
  end

  # 用来处理 Game.rgss3a 文件加密格式不支持的异常
  class RGSS3AFileError < StandardError
    # 引发异常的 rgss3a 文件路径
    #
    # @return [String]
    attr_reader :rgss3a_path

    # 初始化 RGSS3AFileError
    #
    # @param msg [String] 异常信息
    # @param rgss3a_path [String] 引发异常的 rgss3a 文件路径
    #
    # @return [Rvdata2DirError]
    def initialize(rgss3a_path, msg = nil)
      super(msg)
      @rgss3a_path = rgss3a_path
    end
  end

  # 用来处理 rvdata2 文件损坏的异常
  class Rvdata2FileError < StandardError
    # 引发异常的 rvdata2 文件路径
    #
    # @return [String]
    attr_reader :rvdata2_path

    # 初始化 Rvdata2FileError
    #
    # @param msg [String] 异常信息
    # @param rvdata2_path [String] 引发异常的 rvdata2 文件路径
    #
    # @return [Rvdata2DirError]
    def initialize(rvdata2_path, msg = nil)
      super(msg)
      @rvdata2_path = rvdata2_path
    end
  end

  # 用来处理 RPG 模块下 JSON 文件损坏的异常
  class RPGJsonFileError < StandardError
    # 引发异常的 json 文件路径
    #
    # @return [String]
    attr_reader :json_path

    # 初始化 RPGJsonFileError
    #
    # @param msg [String] 异常信息
    # @param json_path [String] 引发异常的 json 文件路径
    #
    # @return [RPGJsonFileError]
    def initialize(json_path, msg = nil)
      super(msg)
      @json_path = json_path
    end
  end

  # 用来处理 R3EXS 模块下 JSON 文件损坏的异常
  class R3EXSJsonFileError < StandardError
    # 引发异常的 json 文件路径
    #
    # @return [String]
    attr_reader :json_path

    # 初始化 R3EXSJsonFileError
    #
    # @param msg [String] 异常信息
    # @param json_path [String] 引发异常的 json 文件路径
    #
    # @return [R3EXSJsonFileError]
    def initialize(json_path, msg = nil)
      super(msg)
      @json_path = json_path
    end
  end

  # 用来处理模块名错误的异常
  class ModuleNameError < ArgumentError
    # 引发异常的模块名
    #
    # @return [Symbol]
    attr_reader :module_name

    # 初始化 ModuleNameError
    #
    # @param msg [String] 异常信息
    # @param module_name [Symbol] 引发异常的模块名
    #
    # @return [ModuleNameError]
    def initialize(module_name, msg = nil)
      super(msg)
      @module_name = module_name
    end
  end

  # 用来处理文件名错误的异常
  class FileBaseNameError < ArgumentError
    # 引发异常的文件名
    #
    # @return [String]
    attr_reader :filebasename

    # 初始化 FileBaseNameError
    #
    # @param msg [String] 异常信息
    # @param filebasename [String] 引发异常的文件名
    #
    # @return [FileBaseNameError]
    def initialize(filebasename, msg = nil)
      super(msg)
      @filebasename = filebasename
    end
  end

  # 用来处理 *.rvdata2 文件目录不存在的异常
  class Rvdata2DirError < IOError
    # 引发异常的 *.rvdata2 文件目录
    #
    # @return [String]
    attr_reader :rvdata2_dir

    # 初始化 Rvdata2DirError
    #
    # @param msg [String] 异常信息
    # @param rvdata2_dir [String] 引发异常的 *.rvdata2 文件目录
    #
    # @return [Rvdata2DirError]
    def initialize(rvdata2_dir, msg = nil)
      super(msg)
      @rvdata2_dir = rvdata2_dir
    end
  end

  # 用来处理 *.json 文件目录不存在的异常
  class JsonDirError < IOError
    # 引发异常的 *.json 文件目录
    #
    # @return [String]
    attr_reader :json_dir

    # 初始化 JsonDirError
    #
    # @param msg [String] 异常信息
    # @param json_dir [String] 引发异常的 *.json 文件目录
    #
    # @return [JsonDirError]
    def initialize(json_dir, msg = nil)
      super(msg)
      @json_dir = json_dir
    end
  end

  # 用来处理 Scripts_info.json 文件不存在的异常
  class ScriptsInfoPathError < IOError
    # 引发异常的 Scripts_info.json 文件路径
    #
    # @return [String]
    attr_reader :scripts_info_path

    # 初始化 ScriptsInfoPathError
    #
    # @param msg [String] 异常信息
    # @param scripts_info_path [String] 引发异常的 Scripts_info.json 文件路径
    #
    # @return [ScriptsInfoPathError]
    def initialize(scripts_info_path, msg = nil)
      super(msg)
      @scripts_info_path = scripts_info_path
    end
  end

  # 用来处理 ManualTransFile.json 文件不存在的异常
  class ManualTransFilePathError < IOError
    # 引发异常的 ManualTransFile.json 文件路径
    #
    # @return [String]
    attr_reader :manualtransfile_path

    # 初始化 ManualTransFilePathError
    #
    # @param msg [String] 异常信息
    # @param manualtransfile_path [String] 引发异常的 ManualTransFile.json 文件路径
    #
    # @return [ManualTransFilePathError]
    def initialize(manualtransfile_path, msg = nil)
      super(msg)
      @manualtransfile_path = manualtransfile_path
    end
  end
end
