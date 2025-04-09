# frozen_string_literal: true

require 'prism'

module R3EXS

    # 用来提取源码生成的 AST 中的字符串和符号
    class StringsExtractor < Prism::Visitor

        # @param strings [Array<String>] 存储提取出的字符串的数组
        # @param with_symbol [Boolean] 是否包含脚本中的符号
        # @return [StringsExtractor]
        def initialize(strings, with_symbol)
            @strings     = strings
            @with_symbol = with_symbol
        end

        # 处理类型为 StringNode 的节点
        #
        # @param node [Prism::StringNode] AST 节点
        # @return [void]
        def visit_string_node(node)
            @strings << node.content
            super
        end

        # 处理类型为 SymbolNode 的节点
        #
        # @param node [Prism::SymbolNode] AST 节点
        # @return [void]
        def visit_symbol_node(node)
            @strings << node.value if @with_symbol
            super
        end

        # 提取后存储的字符串数组
        #
        # @return [Array<String>]
        attr_accessor :strings

        # 是否包含脚本中的符号
        #
        # @return [Boolean]
        attr_accessor :with_symbol

    end

    # 用来替换源码里面的字符串和符号
    class StringsInjector < Prism::Visitor

        # 用来记录字符串的位置
        class Location

            # @note start_offset 是字符串在二进制下打开时的位置
            #
            # @param start_offset [Integer] 字符串在源文件中的起始位置
            # @param length [Integer] 字符串的长度
            # @param content [String] 字符串内容
            # @return [Location]
            def initialize(start_offset, length, content)
                @start_offset = start_offset
                @length       = length
                @content      = content
            end

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

        end

        # @param hash [Hash<String, String>] 字符串翻译表
        # @return [StringsInjector]
        def initialize(hash)
            @strings_hash = hash
            @content_loc  = []
            @code         = []
        end

        # 处理类型为 StringNode 的节点
        #
        # @param node [Prism::StringNode] AST 节点
        # @return [void]
        def visit_string_node(node)
            location = node.content_loc
            value    = location.slice
            if @strings_hash.has_key?(value) && @strings_hash[value].to_s != ''
                @content_loc << Location.new(location.start_offset, location.length, value)
            end
            super
        end

        # 处理类型为 SymbolNode 的节点
        #
        # @param node [Prism::SymbolNode] AST 节点
        # @return [void]
        def visit_symbol_node(node)
            location = node.value_loc
            # 如果 location 不为 nil，说明这个符号是一个字符串
            if location
                value = location.slice
                if @strings_hash.has_key?(value) && @strings_hash[value].to_s != ''
                    @content_loc << Location.new(location.start_offset, location.length, value)
                end
            end
            super
        end

        # 将 script 源码中的字符串替换成 @strings_hash 翻译后的字符串
        #
        # @param script [String] Ruby 源码，以二进制编码打开
        # @param ast_root [Prism::ProgramNode] AST 树根节点
        # @return [String]
        def rewrite(script, ast_root)
            # 首先遍历一遍，找到所有需要替换的字符串的位置
            visit(ast_root)

            # 然后开始替换 code 中的字符串
            # 先将 @content_loc 按照 start_offset 从小到大排序
            @content_loc.sort_by! { |loc| loc.start_offset }

            #  然后将 code 切片，将字符串替换成新的字符串
            start_offset = 0
            @content_loc.each do |loc|
                @code << script[start_offset...loc.start_offset]
                @code << @strings_hash[loc.content]
                start_offset = loc.start_offset + loc.length
            end
            @code << script[start_offset..-1]

            # 将 @code 里面的字符串全部改为二进制编码
            @code.map! { |str| str.force_encoding('ASCII-8BIT') unless str.nil? }
            @code.join
        end

    end

end