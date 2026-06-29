# [R3EXS]

## [2.0.0] - 2026-xx-xx

## [1.1.1] - 2025-07-21

- rgss3a_rvdata2 方法添加 AVX 优化
- rgss3a_rvdata2 方法使用 mmap 代替 fopen

## [1.1.0] - 2025-04-09

- 添加了递归搜索目标目录下的 \*.rvdata2 文件的功能
- 修复了 R3EXS::EventCommand 类里面的 205 和 505 指令的处理问题
- 修复了 StringsInjector 里面的逻辑错误，即在遍历 AST 时，错误地将翻译后的字符串放入 location 中
- gli 版本更新到 2.22.2

## [1.0.5] - 2025-03-12

- rb_in_strings 方法里面添加将 Scripts_info.json 文件拷贝至目标目录里面，以避免后续报错
- 优化了一下 json_rvdata2 方法里的输出

## [1.0.4] - 2025-03-11

- 修复 rvdata2_json 方法里处理 Scripts 的 BUG
- rb_ex_strings 方法里 Extract 单词拼写修正
- oj 版本更新到 3.16.10
- redcarpet 版本更新到 3.6.1

## [1.0.3] - 2025-02-15

- 添加 RGSS3AFileError 类以处理加密格式不支持的问题
- 将 rgss3a_rvdata2 方法里面的文件路径统一为 Unix 格式
- 完善 rgss3a_rvdata2 方法的异常抛出

## [1.0.2] - 2025-02-14

- 将 .yardopts 文件添加到 gem 文件里面以支持 https://rubydoc.info/ 的文档自动生成

## [1.0.1] - 2025-02-14

- 添加了 gemspec 文件里面的 metadata 信息
- 修改了一下生成 yard 文档的选项

## [1.0.0] - 2025-02-13

### 添加功能

- decrypt - 解码 Game.rgss3a 文件
- rvdata2_json - 将 rvdata2 文件序列化为 json 格式
- json_rvdata2 - 将 json 文件反序列化为 rvdata2 文件
- ex_strings - 提取所有的字符串
- in_strings - 注入所有的字符串
