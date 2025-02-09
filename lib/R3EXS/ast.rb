# frozen_string_literal: true
require 'prism'

module R3EXS

    # 用来提取 AST 中的字符串和符号
    class StringsExtractor < Prism::Visitor

        # @param strings [Array<String>] 字符串数组
        # @param with_symbol [Boolean] 是否包含脚本中的符号
        # @return [Void]
        def initialize(strings, with_symbol)
            @strings = strings
            @with_symbol = with_symbol
        end

        # 处理 type 为 String 的节点
        # @param node [Prism::StringNode] AST 节点
        # @return [Void]
        def visit_string_node(node)
            @strings << node.content
            super
        end

        # 处理 type 为 Symbol 的节点
        # @param node [Prism::SymbolNode] AST 节点
        # @return [Void]
        def visit_symbol_node(node)
            @strings << node.value if @with_symbol
            super
        end

    end

    # 用来替换传入的源文件里面的字符串和符号
    class StringsInjector < Prism::Visitor

        # 用来记录字符串的位置
        class Location

            # @param start_offset [Integer] 字符串在源文件中的起始位置
            # @param length [Integer] 字符串的长度
            # @param content [String] 字符串内容
            def initialize(start_offset, length, content)
                @start_offset = start_offset
                @length = length
                @content = content
            end

            attr_reader :start_offset
            attr_reader :length
            attr_reader :content

        end

        # @param hash [Hash] 字符串映射表
        # @return [Void]
        def initialize(hash)
            @strings_hash = hash
            @content_loc = []
            @code = []
        end

        # 处理 type 为 String 的节点
        # @param node [Prism::StringNode] AST 节点
        # @return [Void]
        def visit_string_node(node)
            value = node.content
            if @strings_hash.has_key?(value)
                @content_loc << Location.new(node.content_loc.start_offset, node.content_loc.length, @strings_hash[value])
            end
            super
        end

        # 处理 type 为 Symbol 的节点
        # @param node [Prism::SymbolNode] AST 节点
        # @return [Void]
        def visit_symbol_node(node)
            value = node.value
            if @strings_hash.has_key?(value)
                @content_loc << Location.new(node.value_loc.start_offset, node.value_loc.length, @strings_hash[value])
            end
            super
        end

        # 将 file_dir 文件中的字符串替换成 @strings_hash 翻译后的字符串
        # @param file_dir [String] 源文件路径
        # @param ast [Prism::ProgramNode] AST 树
        def rewrite(file_dir, ast)
            # 读取文件内容
            # 这里必须使用 rb 模式，因为 Prism 定位的位置是二进制下的位置
            # 也就是说没有考虑换行符的问题，所以必须使用二进制模式读取文件
            code = File.read(file_dir, mode: "rb")

            # 首先遍历一遍，找到所有需要替换的字符串的位置
            visit(ast)

            # 然后开始替换 code 中的字符串
            # 先将 @content_loc 按照 start_offset 从小到大排序
            @content_loc.sort_by! { |loc| loc.start_offset }

            #  然后将 code 切片，将字符串替换成新的字符串
            start_offset = 0
            @content_loc.each do |loc|
                @code << code[start_offset...loc.start_offset]
                @code << loc.content
                start_offset = loc.start_offset + loc.length
            end
            @code << code[start_offset..-1]

            # 将 @code 里面的字符串全部改为 UTF-8 编码
            @code.map! { |str| str.force_encoding("UTF-8") }
            @code.join
        end

    end

end
