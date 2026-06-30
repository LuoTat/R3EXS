# frozen_string_literal: true

require 'prism'

module R3EXS
  # 用来提取源码生成的 AST 中的字符串和符号
  class StringsExtractor < Prism::Visitor
    # 提取后存储的字符串数组
    #
    # @return [Array<String>]
    attr_reader :strings

    # 是否包含脚本中的符号
    #
    # @return [Boolean]
    attr_reader :with_symbol

    # AST 根节点
    #
    # @return [Prism::Node]
    attr_reader :root_node

    # 初始化 StringsExtractor
    #
    # @param script [String] Ruby 源码
    # @param with_symbol [Boolean] 是否包含脚本中的符号
    #
    # @return [StringsExtractor]
    def initialize(script, with_symbol)
      super()
      @strings = []
      @with_symbol = with_symbol
      @root_node = Prism.parse(script).value
    end

    # 处理类型为 StringNode 的节点
    #
    # @param node [Prism::StringNode] AST 节点
    #
    # @return [void]
    def visit_string_node(node)
      @strings << node.content
      super
    end

    # 处理类型为 SymbolNode 的节点
    #
    # @param node [Prism::SymbolNode] AST 节点
    #
    # @return [void]
    def visit_symbol_node(node)
      @strings << node.value if @with_symbol
      super
    end

    # 提取 script 源码中的字符串
    #
    # @return [Array<String>]
    def extract
      visit(@root_node)
      @strings
    end

    # 提取 script 源码中的字符串
    # @param script [String] Ruby 源码
    # @param with_symbol [Boolean] 是否包含脚本中的符号
    #
    # @return [Array<String>]
    def self.extract(script, with_symbol)
      extractor = new(script, with_symbol)
      extractor.extract
    end
  end

  # 用来替换源码里面的字符串和符号
  class StringsInjector < Prism::Visitor
    # 字符串在二进制源文件中的位置
    #
    # @return [Array<Location>]
    attr_reader :content_loc

    # Ruby 源码
    #
    # @return [String]
    attr_reader :script

    # 字符串翻译表
    #
    # @return [Hash{String => String}]
    attr_reader :strings_hash

    # AST 根节点
    #
    # @return [Prism::Node]
    attr_reader :root_node

    # 用来记录字符串的位置
    class Location
      # 字符串在二进制源文件中的起始位置
      #
      # @return [Integer]
      attr_reader :start_offset

      # 字符串的长度
      #
      # @return [Integer]
      attr_reader :length

      # 字符串内容
      #
      # @return [String]
      attr_reader :content

      # @note start_offset 是字符串在二进制下打开时的位置
      #
      # @param start_offset [Integer] 字符串在源文件中的起始位置
      # @param length [Integer] 字符串的长度
      # @param content [String] 字符串内容
      #
      # @return [Location]
      def initialize(start_offset, length, content)
        @start_offset = start_offset
        @length = length
        @content = content
      end
    end

    # 初始化 StringsInjector
    #
    # @param script [String] Ruby 源码
    # @param hash [Hash{String => String}] 字符串翻译表
    #
    # @return [StringsInjector]
    def initialize(script, hash)
      super()
      @content_loc = []
      @script = script
      @strings_hash = hash
      @root_node = Prism.parse(script).value
    end

    # 处理类型为 StringNode 的节点
    #
    # @param node [Prism::StringNode] AST 节点
    #
    # @return [void]
    def visit_string_node(node)
      location = node.content_loc
      value = location.slice
      if @strings_hash.key?(value) && @strings_hash[value].to_s != ''
        @content_loc << Location.new(location.start_offset, location.length, value)
      end
      super
    end

    # 处理类型为 SymbolNode 的节点
    #
    # @param node [Prism::SymbolNode] AST 节点
    #
    # @return [void]
    def visit_symbol_node(node)
      location = node.value_loc
      # 如果 location 不为 nil，说明这个符号是一个字符串
      if location
        value = location.slice
        if @strings_hash.key?(value) && @strings_hash[value].to_s != ''
          @content_loc << Location.new(location.start_offset, location.length, value)
        end
      end
      super
    end

    # 将 script 源码中的字符串替换成 @strings_hash 翻译后的字符串
    #
    # @return [String]
    def inject
      code = []
      # 首先遍历一遍，找到所有需要替换的字符串的位置
      visit(@root_node)

      # 然后开始替换 code 中的字符串
      # 先将 @content_loc 按照 start_offset 从小到大排序
      @content_loc.sort_by!(&:start_offset)

      # 然后将 code 切片，将字符串替换成新的字符串
      # 注意 Prism.parse 得到的位置是字节的偏移量，而 UTF-8 是变长编码，所以需要使用 byteslice 来切片
      start_offset = 0
      @content_loc.each do |loc|
        code << @script.byteslice(start_offset...loc.start_offset)
        code << @strings_hash[loc.content]
        start_offset = loc.start_offset + loc.length
      end
      code << @script.byteslice(start_offset..)

      code.join
    end

    # 将 script 源码中的字符串替换成 @strings_hash 翻译后的字符串
    #
    # @param script [String] Ruby 源码
    # @param hash [Hash{String => String}] 字符串翻译表
    #
    # @return [String]
    def self.inject(script, hash)
      injector = new(script, hash)
      injector.inject
    end
  end
end
