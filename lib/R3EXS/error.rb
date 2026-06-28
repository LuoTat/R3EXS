# frozen_string_literal: true

module R3EXS
  # 用来处理 Game.rgss3a 文件加密格式不支持的异常
  class RGSS3AFileError < StandardError
  end

  # 用来处理 RPG 模块下 JSON 文件损坏的异常
  class RPGJsonFileError < StandardError
  end

  # 用来处理 R3EXS 模块下 JSON 文件损坏的异常
  class R3EXSJsonFileError < StandardError
  end

  # 用来处理模块名错误的异常
  class ModuleNameError < ArgumentError
  end

  # 用来处理 *.rvdata2 文件目录不存在的异常
  class Rvdata2DirError < IOError
  end

  # 用来处理 *.json 文件目录不存在的异常
  class JsonDirError < IOError
  end

  # 用来处理 Rvdata2 文件不存在的异常
  class Rvdata2PathError < IOError
  end

  # 用来处理 Scripts_info.json 文件不存在的异常
  class ScriptsInfoPathError < IOError
  end

  # 用来处理 ManualTransFile.json 文件不存在的异常
  class ManualTransFilePathError < IOError
  end
end
