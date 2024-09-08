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

R3EXS is a Ruby-based project designed to extract strings from RGSS3 games. It primarily offers two functions: extracting all strings and injecting the translated strings back into the game, as well as serializing `rvdata2` files into JSON format for manual translation to achieve more precise results.

## [Installation](#table-of-contents)

1. Install [Ruby](https://www.ruby-lang.org/en/)
2. Install the [oj](https://github.com/ohler55/oj) gem

```bash
gem install oj
```

## [Usage](#table-of-contents)

First, unpack the `Game.rgss3a` file from the root directory of the game to obtain the `Data` folder. Then, place the `Data` folder in the same directory as the Ruby scripts.

### Extract All Strings

Run `extract_strings.rb`, and all strings will be extracted into the `ManualTransFile.json` file.

### Inject All Strings

Run `inject_strings.rb`, and all the translated strings from the `ManualTransFile.json` file will be injected back into the `rvdata2` files. The new `rvdata2` files will be placed in the `Data_New` folder.

### Serialize `rvdata2` Files into JSON Format

Run `rvdata2_json.rb`, and all `rvdata2` files will be serialized into JSON format (only attributes in string format will be serialized, essentially tagging all extracted strings with their source). The JSON files will be placed in the `JSON` folder.

### Deserialize JSON Files Back into `rvdata2` Format

Run `json_rvdata2.rb`, and all JSON files will be deserialized back into `rvdata2` files. The new `rvdata2` files will be placed in the `Data_New` folder.

## [Related Links](#table-of-contents)

-   [oj](https://github.com/ohler55/oj)
-   [RGSS3](https://github.com/taroxd/RGSS3)
-   [rvdata2json](https://github.com/DICE2000/rvdata2json)
-   [VX-Ace-Translator](https://github.com/AhmedAhmedEG/VX-Ace-Translator)
-   [RPGMakerDecrypter](https://github.com/uuksu/RPGMakerDecrypter)
