# R3EXS

RGSS3_Extract_Strings_Tool

<p align="center">A tool for extracting and translating strings from the RGSS3 game engine</p>

[**简体中文**](README.md)&nbsp;&nbsp;&nbsp;[**English**](README_EN.md)

## Table of Contents

-   [Introduction](#introduction)
-   [Installation](#installation)
-   [Usage](#usage)
-   [Related Links](#related-links)

## [Introduction](#table-of-contents)

R3EXS is a Ruby-based project designed to extract strings from RGSS3 games. Currently, it provides the following features:

1. [Unpack the Game.rgss3a file](#unpack-the-game.rgss3a-file)

2. [Extract all strings](#extract-all-strings)

3. [Inject translated strings](#inject-translated-strings)

4. [Serialize rvdata2 files into JSON format (strings only)](#serialize-rvdata2-files-into-json-format-strings-only)

5. [Deserialize JSON files back to rvdata2 format (for use with the above feature)](#deserialize-json-files-back-to-rvdata2-format-strings-only)

6. [Serialize rvdata2 files into JSON format (complete serialization)](#serialize-rvdata2-files-into-json-format-complete)

7. [Deserialize JSON files back to rvdata2 format (for use with the above feature)](#deserialize-json-files-back-to-rvdata2-format-complete)

**Note**: Except for functions 6 and 7, please do not delete the Data folder when using other functions.

## [Installation](#table-of-contents)

1. Install [Ruby](https://www.ruby-lang.org/en/)
2. Install the [oj](https://github.com/ohler55/oj) gem

```bash
gem install oj
```

3. Compile `rgss3a_rvdata2.c` (you'll need `gcc` and `make`)

```bash
make
```

## [Usage](#table-of-contents)

First, unpack the Game.rgss3a file from the game's root directory to get the Data folder, and place the Data folder in the same directory as the Ruby scripts.

### Unpack the Game.rgss3a file

Run `rgss3a_rvdata2` directly.

### Extract all strings

Run `extract_strings.rb`. All extracted strings will be saved in the `ManualTransFile.json` file.

### Inject translated strings

Run `inject_strings.rb`. All translated strings in the `ManualTransFile.json` file will be injected into the rvdata2 files. The new rvdata2 files will be placed in the Data_New folder.

### Serialize rvdata2 files into JSON format (partial)

Run `rvdata2_json_part.rb`. All rvdata2 files will be serialized into JSON files (only string properties will be serialized, essentially giving extracted strings a source). The JSON files will be placed in the JSON_Part folder.

### Deserialize JSON files back to rvdata2 format (partial)

Run `json_rvdata2_part.rb`. All JSON files will be deserialized back into rvdata2 format. The new rvdata2 files will be placed in the Data_New folder.

### Serialize rvdata2 files into JSON format (complete)

Run `rvdata2_json_all.rb`. All rvdata2 files will be completely serialized into JSON format. The JSON files will be placed in the JSON folder.

### Deserialize JSON files back to rvdata2 format (complete)

Run `json_rvdata2_all.rb`. All JSON files will be deserialized back into rvdata2 format. The new rvdata2 files will be placed in the Data_New folder.

## [Related Links](#table-of-contents)

-   [oj](https://github.com/ohler55/oj)
-   [RGSS3](https://github.com/taroxd/RGSS3)
-   [rvdata2json](https://github.com/DICE2000/rvdata2json)
-   [VX-Ace-Translator](https://github.com/AhmedAhmedEG/VX-Ace-Translator)
-   [RPGMakerDecrypter](https://github.com/uuksu/RPGMakerDecrypter)
-   [RPGMaker VX Ace F1-Manual](https://miaowm5.github.io/RMVA-F1/)
