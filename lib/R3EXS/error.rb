# frozen_string_literal: true

module R3EXS

    # 用来处理 RPG 模块下的类型错误的异常
    class RPGTypeError < TypeError

        # @param msg [String] 异常信息
        # @param obj [Object] 引发异常的类
        # @return [RPGTypeError]
        def initialize(msg = '', obj)
            super(msg)
            @obj = obj
        end

        # 引发异常的类
        #
        # @return [Object]
        attr_reader :obj
    end

    # 用来处理 R3EXS 模块下的类型错误的异常
    class R3EXSTypeError < TypeError

        # @param msg [String] 异常信息
        # @param obj [Object] 引发异常的的类型
        # @return [R3EXSTypeError]
        def initialize(msg = '', obj)
            super(msg)
            @obj = obj
        end

        # 引发异常的类型
        #
        # @return [Object]
        attr_reader :obj
    end

    # 用来处理 rvdata2 文件损坏的异常
    class Rvdata2FileError < StandardError

        # @param msg [String] 异常信息
        # @param rvdata2_path [String] 引发异常的 rvdata2 文件路径
        # @return [Rvdata2DirError]
        def initialize(msg = '', rvdata2_path)
            super(msg)
            @rvdata2_path = rvdata2_path
        end

        # 引发异常的 rvdata2 文件路径
        #
        # @return [String]
        attr_reader :rvdata2_path
    end

    # 用来处理 RPG 模块下 JSON 文件损坏的异常
    class RPGJsonFileError < StandardError

        # @param msg [String] 异常信息
        # @param json_path [String] 引发异常的 json 文件路径
        # @return [RPGJsonFileError]
        def initialize(msg = '', json_path)
            super(msg)
            @json_path = json_path
        end

        # 引发异常的 json 文件路径
        #
        # @return [String]
        attr_reader :json_path
    end

    # 用来处理 R3EXS 模块下 JSON 文件损坏的异常
    class R3EXSJsonFileError < StandardError

        # @param msg [String] 异常信息
        # @param json_path [String] 引发异常的 json 文件路径
        # @return [R3EXSJsonFileError]
        def initialize(msg = '', json_path)
            super(msg)
            @json_path = json_path
        end

        # 引发异常的 json 文件路径
        #
        # @return [String]
        attr_reader :rvdata2_path
    end

    # 用来处理模块名错误的异常
    class ModuleNameError < ArgumentError

        # @param msg [String] 异常信息
        # @param module_name [Symbol] 引发异常的模块名
        # @return [ModuleNameError]
        def initialize(msg = '', module_name)
            super(msg)
            @module_name = module_name
        end

        # 引发异常的模块名
        #
        # @return [Symbol]
        attr_reader :module_name
    end

    # 用来处理文件名错误的异常
    class FileBaseNameError < ArgumentError

        # @param msg [String] 异常信息
        # @param filebasename [String] 引发异常的文件名
        # @return [FileBaseNameError]
        def initialize(msg = '', filebasename)
            super(msg)
            @filebasename = filebasename
        end

        # 引发异常的文件名
        #
        # @return [String]
        attr_reader :filebasename
    end

    # 用来处理 *.rvdata2 文件目录不存在的异常
    class Rvdata2DirError < IOError

        # @param msg [String] 异常信息
        # @param rvdata2_dir [String] 引发异常的 *.rvdata2 文件目录
        # @return [Rvdata2DirError]
        def initialize(msg = '', rvdata2_dir)
            super(msg)
            @rvdata2_dir = rvdata2_dir
        end

        # 引发异常的 *.rvdata2 文件目录
        #
        # @return [String]
        attr_reader :rvdata2_dir
    end

    # 用来处理 *.json 文件目录不存在的异常
    class JsonDirError < IOError

        # @param msg [String] 异常信息
        # @param json_dir [String] 引发异常的 *.json 文件目录
        # @return [JsonDirError]
        def initialize(msg = '', json_dir)
            super(msg)
            @json_dir = json_dir
        end

        # 引发异常的 *.json 文件目录
        #
        # @return [String]
        attr_reader :json_dir
    end

    # 用来处理 *.rb 文件目录不存在的异常
    class ScriptsDirError < IOError

        # @param msg [String] 异常信息
        # @param scripts_dir [String] 引发异常的 *.rb 文件目录
        # @return [ScriptsDirError]
        def initialize(msg = '', scripts_dir)
            super(msg)
            @scripts_dir = scripts_dir
        end

        # 引发异常的 *.rb 文件目录
        #
        # @return [String]
        attr_reader :scripts_dir
    end

    # 用来处理 Scripts_info.json 文件不存在的异常
    class ScriptsInfoPathError < IOError

        # @param msg [String] 异常信息
        # @param scripts_info_path [String] 引发异常的 Scripts_info.json 文件路径
        # @return [ScriptsInfoPathError]
        def initialize(msg = '', scripts_info_path)
            super(msg)
            @scripts_info_path = scripts_info_path
        end

        # 引发异常的 Scripts_info.json 文件路径
        #
        # @return [String]
        attr_reader :scripts_info_path
    end

    # 用来处理 ManualTransFile.json 文件不存在的异常
    class ManualTransFilePathError < IOError

        # @param msg [String] 异常信息
        # @param manualtransfile_path [String] 引发异常的 ManualTransFile.json 文件路径
        # @return [ManualTransFilePathError]
        def initialize(msg = '', manualtransfile_path)
            super(msg)
            @manualtransfile_path = manualtransfile_path
        end

        # 引发异常的 ManualTransFile.json 文件路径
        #
        # @return [String]
        attr_reader :manualtransfile_path
    end

end