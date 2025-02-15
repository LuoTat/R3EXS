# [R3EXS]

## [1.0.3] - 2025-02-15

-   添加 RGSS3AFileError 类以处理加密格式不支持的问题
-   将 rgss3a_rvdata2 方法里面的文件路径统一为 Unix 格式
-   完善 rgss3a_rvdata2 方法的异常抛出

## [1.0.2] - 2025-02-14

-   将 .yardopts 文件添加到 gem 文件里面以支持 https://rubydoc.info/ 的文档自动生成

## [1.0.1] - 2025-02-14

-   添加了 gemspec 文件里面的 metadata 信息
-   修改了一下生成 yard 文档的选项

## [1.0.0] - 2025-02-13

### 添加功能

-   decrypt - 解码 Game.rgss3a 文件
-   rvdata2_json - 将 rvdata2 文件序列化为 json 格式
-   json_rvdata2 - 将 json 文件反序列化为 rvdata2 文件
-   ex_strings - 提取所有的字符串
-   in_strings - 注入所有的字符串
