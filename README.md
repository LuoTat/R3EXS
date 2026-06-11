# R3EXS

RGSS3_Extract_Strings_Tool

<p style="text-align: center;">一个用来提取和翻译 RGSS3 游戏引擎的字符串的工具</p>

[**简体中文**](README.md)&nbsp;&nbsp;&nbsp;[**English**](README_EN.md)

## 目录

- [简介](#简介)
- [特点](#特点)
- [功能列表](#功能列表)
- [安装方法](#安装方法)
- [使用方法](#使用方法)
- [项目构建](#项目构建)
- [项目文档](#项目文档)
- [友情链接](#友情链接)

## [简介](#目录)

R3EXS 是一个基于 Ruby 语言，用来提取和翻译 RGSS3 游戏里字符串的 gem

## [特点](#目录)

使用 [Prism](https://github.com/ruby/prism) 实现了对 Ruby 脚本中的字符串和符号的精准提取

## [功能列表](#目录)

1. [解包 Game.rgss3a 文件](#解包-Gamergss3a-文件)
2. [序列化 rvdata2 文件为 json 格式](#序列化-rvdata2-文件为-json-格式)
3. [反序列化 json 文件为 rvdata2 格式](#反序列化-json-文件为-rvdata2-格式)
4. [提取所有的字符串](#提取所有的字符串)
5. [注入所有的字符串](#注入所有的字符串)

## [安装方法](#目录)

### 使用 RubyGems 安装

1. 安装 [Ruby](https://www.ruby-lang.org/zh_cn) (要附带安装 Devkit 来支持编译 C 扩展)
2. 安装 [R3EXS](https://rubygems.org/gems/R3EXS) gem

```bash
gem install R3EXS
```

### 直接下载 exe 可执行文件

点击下载 [R3EXS.exe](https://github.com/LuoTat/R3EXS/releases)

使用 [Ocran](https://github.com/Largo/ocran) 和 [Tebako](https://github.com/tamatebako/tebako) 两个打包工具

`Windows` 环境提供 `R3EXS-windows-Ocran` 和 `R3EXS-windows-Tebako`

`Linux (GLIBC>=2.31)` 环境提供 `R3EXS-linux-Tebako`

在首次运行时会解压 Ruby 环境，所以首次运行会比较慢

## [使用方法](#目录)

以下代码均假设在游戏根目录下运行，确保 `./Game.rgss3a` 文件存在，或者已经解包到 `./Data` 文件夹下

~~如果你喜欢疯狂输出的控制台或者觉得运行太快~~，请开启 `--verbose` 选项

### [解包 Game.rgss3a 文件](#功能列表)

```bash
NAME
    decrypt - 解码 Game.rgss3a 文件

SYNOPSIS

    R3EXS [global options] decrypt [command options] <Game.rgss3a file path>

COMMAND OPTIONS
    -o, --output_dir=DIRECTORY -  *.rvdata2 文件的输出目录 (默认: ./)
```

示例代码

```bash
R3EXS decrypt ./Game.rgss3a
```

### [序列化 rvdata2 文件为 json 格式](#功能列表)

```bash
NAME
    rvdata2_json - 将 rvdata2 文件序列化为 json 格式

SYNOPSIS

    R3EXS [global options] rvdata2_json [command options] <the *.rvdata2 dir>

COMMAND OPTIONS
    -c, --[no-]complete        - 开启完全序列化
    -n, --[no-]with_notes      - 开启注释序列化
    -o, --output_dir=DIRECTORY - *.json 文件的输出目录 (默认: ./JSON)
    -s, --[no-]with_scripts    - 开启 Scripts 脚本序列化
```

示例代码

```bash
// 只序列化可翻译部分
R3EXS rvdata2_json ./Data

// 完全序列化
R3EXS rvdata2_json -c ./Data
```

### [反序列化 json 文件为 rvdata2 格式](#功能列表)

```bash
NAME
    json_rvdata2 - 将 json 文件反序列化为 rvdata2 文件

SYNOPSIS

    R3EXS [global options] json_rvdata2 [command options] <the *.json dir>

COMMAND OPTIONS
    -c, --[no-]complete          - 开启完全反序列化
    -o, --output_dir=DIRECTORY   - 新的 *.rvdata2 文件的输出路径 (默认: ./Data_NEW)
    -r, --original_dir=DIRECTORY - 原始的 *.rvdata2 文件路径 (默认: ./Data)
    -s, --[no-]with_scripts      - 开启 Scripts 脚本反序列化
```

示例代码

```bash
// 如果在 rvdata2_json 时没有开启 --complete 选项
// 则必须提供 --original_dir 或是当前目录下存在 ./Data 文件夹
R3EXS json_rvdata2 ./JSON

// 如果在 rvdata2_json 时开启 --complete 选项
// 则不需要提供 --original_dir 选项
R3EXS json_rvdata2 -c ./JSON
```

### [提取所有的字符串](#功能列表)

```bash
NAME
    ex_strings - 提取所有的字符串

SYNOPSIS

    R3EXS [global options] ex_strings [command options] <the *.json dir>

COMMAND OPTIONS
    -o, --output_dir=DIRECTORY       - ManualTransFile.json 或 ManualTransFile_scripts.json 文件的输出目录 (默认: ./)
    -p, --[no-]with_scripts_separate - 开启 Scripts 脚本单独提取到 ManualTransFile_scripts.json 文件
    -s, --[no-]with_scripts          - 开启 Scripts 脚本提取
    -y, --[no-]with_symbol           - 开启 Scripts 脚本中的 Symbol 提取
```

示例代码

```bash
// 不提取 Scripts 脚本
R3EXS ex_strings ./JSON

// 提取 Scripts 脚本
R3EXS ex_strings -s ./JSON

// 提取 Scripts 脚本并单独提取到 ManualTransFile_scripts.json 文件
R3EXS ex_strings -s -p ./JSON
```

### [注入所有的字符串](#功能列表)

```bash
NAME
    in_strings - 注入所有的字符串

SYNOPSIS

    R3EXS [global options] in_strings [command options] <the *.json dir>

COMMAND OPTIONS
    -m, --manualtransfile_path=FILE - ManualTransFile.json 文件路径 (默认: ./ManualTransFile.json)
    -o, --output_dir=DIRECTORY      - 新的 *.json 文件的输出目录 (默认: ./JSON_NEW)
    -s, --[no-]with_scripts         - 开启 Scripts 脚本注入
```

示例代码

```bash
// 不注入到 Scripts 脚本
R3EXS in_strings ./JSON

// 注入到 Scripts 脚本
R3EXS in_strings -s ./JSON
```

---

想要获取更多帮助，使用

```bash
R3EXS help
```

## [项目构建](#目录)

如果想要构建项目并运行，首先克隆整个项目

```bash
git clone https://github.com/LuoTat/R3EXS.git
```

然后使用 `bundle` 安装依赖

```bash
bundle install
```

最后编译 C 扩展即可

```bash
rake compile
```

---

构建本地文档

```bash
yardoc
```

构建 `R3EXS_Ocran.exe` 可执行文件

```bash
rake ocran
```

查看所有 rake 任务

```bash
rake -T
```

## [项目文档](#目录)

[R3EXS Api 文档](https://rubydoc.info/gems/R3EXS)

## [友情链接](#目录)

- [oj](https://github.com/ohler55/oj)
- [gli](https://github.com/davetron5000/gli)
- [Prism](https://github.com/ruby/prism)
- [Ocran](https://github.com/Largo/ocran)
- [Tebako](https://github.com/tamatebako/tebako)
- [RGSS3](https://github.com/taroxd/RGSS3)
- [rvdata2json](https://github.com/DICE2000/rvdata2json)
- [VX-Ace-Translator](https://github.com/AhmedAhmedEG/VX-Ace-Translator)
- [RPGMakerDecrypter](https://github.com/uuksu/RPGMakerDecrypter)
- [RPGMaker VX Ace F1-Manual](https://miaowm5.github.io/RMVA-F1)
