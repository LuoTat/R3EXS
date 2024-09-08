# R3EXS

RGSS3_Extract_Strings_Tool

<p align="center">一个用来提取和翻译RGSS3游戏引擎的字符串的工具</p>

[**简体中文**](README.md)&nbsp;&nbsp;&nbsp;[**English**](README_EN.md)

## 目录

-   [简介](#简介)
-   [安装方法](#安装方法)
-   [使用方法](#使用方法)
-   [友情链接](#友情链接)

## [简介](#目录)

R3EXS 是一个基于 Ruby 语言用来提取 RGSS3 游戏里字符串的项目，主要有两个功能，提取所有的字符串以及注入翻译后的字符串和把 rvdata2 文件序列化为 json 文件来手动翻译以获得更精细的结果

## [安装方法](#目录)

1. 安装[Ruby](https://www.ruby-lang.org/zh_cn/)
2. 安装 [oj](https://github.com/ohler55/oj) gem

```bash
gem install oj
```

## [使用方法](#目录)

首先将游戏根目录中的 Game.rgss3a 文件解包，得到 Data 文件夹，然后让 Data 文件夹与 Ruby 脚本在同一目录下

### 提取所有的字符串

直接运行`extract_strings.rb`，所有的字符串将提取至`ManualTransFile.json`文件中

### 注入所有的字符串

直接运行`inject_strings.rb`，则`ManualTransFile.json`文件中所有翻译了的字符串都将注入到 rvdata2 文件中，新的 rvdata2 文件将放在 Data_New 文件夹下

### 序列化 rvdata2 文件为 json 格式

直接运行`rvdata2_json.rb`，则会把所有的 rvdata2 文件全部序列化为 json 文件(只会序列化其格式为字符串的属性，本质上就是给所有提取了的字符串加上了来源)，json 文件将会放在 JSON 文件夹下

### 反序列化 json 文件为 rvdata2 格式

直接运行`json_rvdata2.rb`，则会把所有的 json 文件全部反序列化为 rvdata2 文件，新的 rvdata2 文件将放在 Data_New 文件夹下

## [友情链接](#目录)

-   [oj](https://github.com/ohler55/oj)
-   [RGSS3](https://github.com/taroxd/RGSS3)
-   [rvdata2json](https://github.com/DICE2000/rvdata2json)
-   [VX-Ace-Translator](https://github.com/AhmedAhmedEG/VX-Ace-Translator)
-   [RPGMakerDecrypter](https://github.com/uuksu/RPGMakerDecrypter)
