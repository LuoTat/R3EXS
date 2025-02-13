# R3EXS

RGSS3_Extract_Strings_Tool

<p style="text-align: center;">A tool for extracting and translating strings from the RGSS3 game engine.</p>

[**English**](README_EN.md)&nbsp;&nbsp;&nbsp;[**简体中文**](README.md)

## Contents

-   [Synopsis](#synopsis)
-   [Features](#features)
-   [Function List](#function-list)
-   [Installation](#installation)
-   [Usage](#usage)
-   [Project Build](#project-build)
-   [Documentation](#documentation)
-   [Links](#links)

## [Synopsis](#contents)

R3EXS is a gem built using Ruby, designed to extract and translate strings in RGSS3 games.

## [Features](#contents)

It uses [Prism](https://github.com/ruby/prism) to accurately extract strings and symbols from Ruby scripts.

## [Function List](#contents)

1. [Unpack Game.rgss3a file](#unpack-game-rgss3a-file)
2. [Serialize rvdata2 files to JSON file](#serialize-rvdata2-files-to-json-file)
3. [Deserialize JSON files to rvdata2 file](#deserialize-json-files-to-rvdata2-file)
4. [Extract all strings](#extract-all-strings)
5. [Inject all strings](#inject-all-strings)

## [Installation](#contents)

### Install using RubyGems

1. Install [Ruby](https://www.ruby-lang.org/en/) (make sure to install Devkit to support compiling C extensions)
2. Install the [R3EXS](https://rubygems.org/gems/r3exs) gem

```bash
gem install R3EXS
```

### Download executable file directly

Click to download [R3EXS.exe](https://github.com/LuoTat/R3EXS/releases)

Since the R3EXS.exe file is packaged using [Ocran](https://github.com/Largo/ocran) and [Tebako](https://github.com/tamatebako/tebako)

The `Windows` environment provides `R3EXS_Ocran` and `R3EXS_Tebako`

The `Linux (GLIBC >= 2.31)` environment provides `R3EXS_Tebako`

it will extract the Ruby environment the first time it runs, so the first run may be slower.

## [Usage](#contents)

The following commands assume they are run in the game’s root directory, ensuring the `./Game.rgss3a` file exists or has already been unpacked into the `./Data` folder.

~~If you enjoy a crazy amount of console output or feel like the execution is too fast~~, please enable the `--verbose` option.

### [Unpack Game.rgss3a file](#function-list)

```bash
NAME
    decrypt - Decrypt the Game.rgss3a file

SYNOPSIS

    R3EXS [global options] decrypt [command options] <Game.rgss3a file path>

COMMAND OPTIONS
    -o, --output_dir=DIRECTORY - The *.rvdata2 output dir (default: ./)
```

Example code:

```bash
R3EXS decrypt ./Game.rgss3a
```

### [Serialize rvdata2 files to JSON file](#function-list)

```bash
NAME
    rvdata2_json - Serialize rvdata2 files into JSON

SYNOPSIS

    R3EXS [global options] rvdata2_json [command options] <the *.rvdata2 dir>

COMMAND OPTIONS
    -c, --[no-]complete        - Enable complete serialization
    -n, --[no-]with_notes      - Enable notes attribute serialization
    -o, --output_dir=DIRECTORY - The *.json output dir (default: ./JSON)
    -s, --[no-]with_scripts    - Enable Scripts.rvdata2 serialization
```

Example code:

```bash
// Serialize only translatable parts
R3EXS rvdata2_json ./Data

// Complete serialization
R3EXS rvdata2_json -c ./Data
```

### [Deserialize JSON files to rvdata2 file](#function-list)

```bash
NAME
    json_rvdata2 - Deserialize JSON files back into rvdata2

SYNOPSIS

    R3EXS [global options] json_rvdata2 [command options] <the *.json dir>

COMMAND OPTIONS
    -c, --[no-]complete          - Enable complete deserialization
    -o, --output_dir=DIRECTORY   - The NEW *.rvdata2 output dir (default: ./Data_NEW)
    -r, --original_dir=DIRECTORY - The ORIGINAL *.rvdata2 dir (default: ./Data)
    -s, --[no-]with_scripts      - Enable Scripts JSON deserialization
```

Example code:

```bash
// If --complete was not enabled in rvdata2_json
// Provide --original_dir or ensure ./Data folder exists in the current directory
R3EXS json_rvdata2 ./JSON

// If --complete was enabled in rvdata2_json
// --original_dir is not required
R3EXS json_rvdata2 -c ./JSON
```

### [Extract all strings](#function-list)

```bash
NAME
    ex_strings - Extract all strings

SYNOPSIS

    R3EXS [global options] ex_strings [command options] <the *.json dir>

COMMAND OPTIONS
    -o, --output_dir=DIRECTORY       - The ManualTransFile.json or ManualTransFile_scripts.json output dir (default: ./)
    -p, --[no-]with_scripts_separate - Enable Scripts extraction into a separate ManualTransFile_scripts.json
    -s, --[no-]with_scripts          - Enable Scripts extraction
    -y, --[no-]with_symbol           - Enable Symbol extraction in Scripts extraction
```

Example code:

```bash
// Do not extract Scripts
R3EXS ex_strings ./JSON

// Extract Scripts
R3EXS ex_strings -s ./JSON

// Extract Scripts and separate them into ManualTransFile_scripts.json
R3EXS ex_strings -s -p ./JSON
```

### [Inject all strings](#function-list)

```bash
NAME
    in_strings - Inject all strings

SYNOPSIS

    R3EXS [global options] in_strings [command options] <the *.json dir>

COMMAND OPTIONS
    -m, --manualtransfile_path=FILE - The ManualTransFile.json path (default: ./ManualTransFile.json)
    -o, --output_dir=DIRECTORY      - The NEW *.json output dir (default: ./JSON_NEW)
    -s, --[no-]with_scripts         - Enable Scripts Injection
```

Example code:

```bash
// Do not inject into Scripts
R3EXS in_strings ./JSON

// Inject into Scripts
R3EXS in_strings -s ./JSON
```

---

For more information, use

```bash
R3EXS help
```

## [Project Build](#contents)

To build and run the project, first clone the entire repository:

```bash
git clone git@github.com:LuoTat/R3EXS.git
```

Then use `bundle` to install dependencies:

```bash
bundle install
```

Finally, compile the C extension:

```bash
rake compile
```

---

Build the local documentation:

```bash
yardoc
```

Build the `R3EXS_Ocran.exe` file:

```bash
rake ocran
```

View all rake tasks:

```bash
rake -T
```

## [Documentation](#contents)

[R3EXS Api Documentation](https://rubydoc.info/gems/R3EXS)

## [Links](#contents)

-   [oj](https://github.com/ohler55/oj)
-   [gli](https://github.com/davetron5000/gli)
-   [Prism](https://github.com/ruby/prism)
-   [Ocran](https://github.com/Largo/ocran)
-   [Tebako](https://github.com/tamatebako/tebako)
-   [RGSS3](https://github.com/taroxd/RGSS3)
-   [rvdata2json](https://github.com/DICE2000/rvdata2json)
-   [VX-Ace-Translator](https://github.com/AhmedAhmedEG/VX-Ace-Translator)
-   [RPGMakerDecrypter](https://github.com/uuksu/RPGMakerDecrypter)
-   [RPGMaker VX Ace F1-Manual](https://miaowm5.github.io/RMVA-F1)
