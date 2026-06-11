# frozen_string_literal: true

require 'oj'
require_relative 'RGSS3'
require_relative 'RGSS3_R3EXS'

module R3EXS
  # 工具模块
  # 主要用来提供一些读取，写入，转换等功能
  module Utils
    # 用来匹配读取的 rvdata2 文件名
    RVDATA2_FILE_NAME =
      [
        /\AActors\z/,
        /\AAnimations\z/,
        /\AArmors\z/,
        /\AClasses\z/,
        /\ACommonEvents\z/,
        /\AEnemies\z/,
        /\AItems\z/,
        /\AMap\d{3}\z/,
        /\AMapInfos\z/,
        /\AScripts\z/,
        /\ASkills\z/,
        /\AStates\z/,
        /\ASystem\z/,
        /\ATilesets\z/,
        /\ATroops\z/,
        /\AWeapons\z/
      ].freeze

    # 用来匹配读取的 JSON 文件名
    JSON_FILE_NAME =
      [
        /\AActors\z/,
        /\AAnimations\z/,
        /\AArmors\z/,
        /\AClasses\z/,
        /\AEnemies\z/,
        /\AItems\z/,
        /\AMap\d{3}\z/,
        /\AMapInfos\z/,
        /\ASkills\z/,
        /\AStates\z/,
        /\ASystem\z/,
        /\ATilesets\z/,
        /\ATroops\z/,
        /\AWeapons\z/
      ].freeze

    # 用来匹配读取的文件名到对应的R3EXS的类
    FILE_BASENAME_TO_CLASS_R3EXS = {
      /\AActors\z/ => R3EXS::Actor,
      /\AAnimations\z/ => R3EXS::Animation,
      /\AArmors\z/ => R3EXS::Armor,
      /\AClasses\z/ => R3EXS::Class,
      /\ACommonEvents\z/ => R3EXS::CommonEvent,
      /\AEnemies\z/ => R3EXS::Enemy,
      /\AItems\z/ => R3EXS::Item,
      /\AMap\d{3}\z/ => R3EXS::Map,
      /\AMapInfos\z/ => R3EXS::MapInfo,
      /\ASkills\z/ => R3EXS::Skill,
      /\AStates\z/ => R3EXS::State,
      /\ASystem\z/ => R3EXS::System,
      /\ATilesets\z/ => R3EXS::Tileset,
      /\ATroops\z/ => R3EXS::Troop,
      /\AWeapons\z/ => R3EXS::Weapon
    }.freeze

    # 用来匹配读取的文件名到对应的RPG的类
    FILE_BASENAME_TO_CLASS_RPG = {
      /\AActors\z/ => RPG::Actor,
      /\AAnimations\z/ => RPG::Animation,
      /\AArmors\z/ => RPG::Armor,
      /\AClasses\z/ => RPG::Class,
      /\ACommonEvents\z/ => RPG::CommonEvent,
      /\AEnemies\z/ => RPG::Enemy,
      /\AItems\z/ => RPG::Item,
      /\AMap\d{3}\z/ => RPG::Map,
      /\AMapInfos\z/ => RPG::MapInfo,
      /\ASkills\z/ => RPG::Skill,
      /\AStates\z/ => RPG::State,
      /\ASystem\z/ => RPG::System,
      /\ATilesets\z/ => RPG::Tileset,
      /\ATroops\z/ => RPG::Troop,
      /\AWeapons\z/ => RPG::Weapon
    }.freeze

    # 事件指令的命令名称
    EVENT_COMMANDS = {
      0 => 'Empty',

      #     [string(Face Graphic name)]---[int(Face Graphic index)]---[int:{0:Normal Window, 1:Dim Background, 2:Transparent}]---[int:{0:Top, 1:Middle, 2:Bottom}]---END
      101 => 'ShowTextAttributes',

      #     [Array<string>(Choices Array)]---[int:{0:Disallow, 1:Choice 1, 2:Choice 2, 3:Choice 3, 4:Choice 4, 5:Branch}(When Cancel)]---END
      102 => 'ShowChoices',

      #     [int(Variable for Number)]---[int:{1~8}(Digits)]---END
      103 => 'InputNumber',

      #     [int(Variable for Item ID)]---END
      104 => 'SelectKeyItem',

      #     [int:{1~8}(Speed)]---[bool(No Fast Forward)]---END
      105 => 'ShowScrollingTextAttributes',

      #     [string]---END
      108 => 'Comment',

      #     |--[int:0(Switch)]---[int(Switch ID)]---[int{0:ON, 1:OFF}]---END
      #     |
      #     |                                          |--[int:0(Compare to Constant)]---[int(Number)]-------|
      #     |--[int:1(Variable)]---[int(Variable ID)]--|                                                     |--[int{0:==, 1:>=, 2:<=, 3:>, 4:<, 5:!=}]---END
      #     |                                          |--[int:1(Compare to Variable)]---[int(Variable ID)]--|
      #     |
      #     |--[int:2(Self Switch)]---[string{'A', 'B', 'C', 'D'}]---[int{0:ON, 1:OFF}]---END
      #     |
      #     |--[int:3(Timer)]---[int:{0~5999}(sec)]---[int{0:>=, 1:<=}]---END
      #     |
      #     |                                          |--[int:0(In the Party)]---END
      #     |                                          |
      #     |                                          |--[int:1(Name)]---[string]---END
      #     |                                          |
      #     |                                          |--[int:2(Class)]---[int(Class ID)]---END
      #     |                                          |
      #     |--[int:4(Actor)]---[int(Actor ID)]--------|--[int:3(Skill)]---[int(Skill ID)]---END
      #     |                                          |
      #     |                                          |--[int:4(Weapon)]---[int(Wwapon ID)]---END
      #     |                                          |
      #     |                                          |--[int:5(Armor)]---[int(Armor ID)]---END
      #     |                                          |
      #     |                                          |--[int:6(State)]---[int(State ID)]---END
      #     |
      #     |                                          |--[int:0(Appeared)---END
      #     |--[int:5(Enemy)]---[int(Enemy ID)]--------|
      #     |                                          |--[int:1(State)]---[int(State ID)]---END
      #     |
      #     |--[int:6(Character)]---[int:{-1:Player, 0:This event, 1:EV001, ...}]---[int:{2:Down, 4:Left, 6:Right, 8:Up}]---END
      #     |
      #     |--[int:7(Gold)]---[int(Money)]---[int{0:>=, 1:<=, 2:<}]---END
      #     |
      #     |--[int:8(Item)]---[int(Item ID)]---END
      #     |
      #     |--[int:9(Weapon)]---[int(Weapon ID)]---[bool(Include Equipments)]---END
      #     |
      #     |--[int:10(Armor)]---[int(Armor ID)]---[bool(Include Equipments)]---END
      #     |
      #     |--[int:11(Button)]---[int:{2:Down, 4:Left, 6:Right, 8:Up, 11:A, 12:B, 13:C, 14:X, 15:Y, 16:Z, 17:L, 18:R}]---END
      #     |
      #     |--[int:12(Script)]---[string]---END
      #     |
      #     |--[int:13(Vehicle)]---[int:{0:Boat, 1:Ship, 2:Airship}]---END
      111 => 'ConditionalBranch',
      112 => 'Loop',
      113 => 'BreakLoop',
      115 => 'ExitEventProcessing',

      #     [int(Common Event ID)]---END
      117 => 'CallCommonEvent',

      #     [string]---END
      118 => 'Label',

      #     [string]---END
      119 => 'JumpToLabel',

      #     [int(Switch Begin ID)]---[int(Switch End ID)]---[int:{0:ON, 1:OFF}]---END
      121 => 'ControlSwitches',

      #                                                                                                           |--[int:0(Constant)]---[int(Number)]---END
      #                                                                                                           |
      #                                                                                                           |--[int:1(Variable)]---[int(Variable ID)]---END
      #                                                                                                           |
      #                                                                                                           |--[int:2(Random)]---[int(Min)]---[int(Max)]---END
      #                                                                                                           |
      #                                                                                                           |                      |--[int:{0:Item, 1:Weapon, 2:Armor}]---[int(Corresponded Item ID)]---[int:0]---END
      #                                                                                                           |                      |
      #     [int(Variable Begin ID)]---[int(Variable End ID)]---[int:{0:Set, 1:Add, 2:Sub, 3:Mul, 4:Div, 5:Mod}]--|                      |--[int:3(Actor)]---[int:(Actor ID)]---[int:{0:Level, 1:EXP, 2:HP, 3:MP, 4:MHP, 5:MMP, 6:ATK, 7:DEF, 8:MAT, 9:MDF, 10:AGI, 11:LUK}]---END
      #                                                                                                           |                      |
      #                                                                                                           |                      |--[int:4(Enemy)]---[int:(Enemy ID)]---[int:{0:HP, 1:MP, 2:MHP, 3:MMP, 4:ATK, 5:DEF, 6:MAT, 7:MDF, 8:AGI, 9:LUK}]---END
      #                                                                                                           |--[int:3(Game Data)]--|
      #                                                                                                           |                      |--[int:5(Character)]---[int:{-1:Player, 0:This Event, 1:EV001, ...}]---[int:{0:Map X, 1:Map Y, 2:Direction, 3:Screen X ,4:Screen Y}]---END
      #                                                                                                           |                      |
      #                                                                                                           |                      |--[int:6(Party)]---[int:{0~7}(Member ID)]---[int:0]---END
      #                                                                                                           |                      |
      #                                                                                                           |                      |--[int:7(Other)]---[int:{0(Map ID), 1(Party Members), 2(Gold), 3(Steps), 4(Play Time), 5(Timer), 6(Save Count), 7(Battle Count)}]---[int:0]---END
      #                                                                                                           |
      #                                                                                                           |--[int:4(Scripts)]---[string]---END
      122 => 'ControlVariables',

      #     [string:{'A', 'B', 'C', 'D'}(Self Switch Name)]---[int:{0:ON, 1:OFF}]---END
      123 => 'ControlSelfSwitch',

      #     [int:{0:Start, 1:Stop}]---[int:{0~5999}(sec)]---END
      124 => 'ControlTimer',

      #                                     |--[int:0(Constant)]---[int:{0~9999999}(Number)]---END
      #     [int:{0:Increase, 1:Decrease}]--|
      #                                     |--[int:1(Variable)]---[int(Variable ID)]---END
      125 => 'ChangeGold',

      #                                                      |--[int:0(Constant)]---[int:{0~9999999}(Number)]---END
      #     [int(Item ID)]---[int:{0:Increase, 1:Decrease}]--|
      #                                                      |--[int:1(Variable)]---[int(Variable ID)]---END
      126 => 'ChangeItems',

      #                                             |--[int:0(Constant)]---[int:{0~9999999}(Number)]--|
      #                       |--[int:0(Increase)]--|                                                 |--[bool:false(Include Equipment)]---END
      #                       |                     |--[int:1(Variable)]---[int(Variable ID)]---------|
      #     [int(Weapon ID)]--|
      #                       |                     |--[int:0(Constant)]---[int:{0~9999999}(Number)]--|
      #                       |--[int:1(Decrease)]--|                                                 |--[bool(Include Equipment)]---END
      #                                             |--[int:1(Variable)]---[int(Variable ID)]---------|
      127 => 'ChangeWeapons',

      #                                            |--[int:0(Constant)]---[int:{0~9999999}(Number)]--|
      #                      |--[int:0(Increase)]--|                                                 |--[bool:false(Include Equipment)]---END
      #                      |                     |--[int:1(Variable)]---[int(Variable ID)]---------|
      #     [int(Armor ID)]--|
      #                      |                     |--[int:0(Constant)]---[int:{0~9999999}(Number)]--|
      #                      |--[int:1(Decrease)]--|                                                 |--[bool(Include Equipment)]---END
      #                                            |--[int:1(Variable)]---[int(Variable ID)]---------|
      128 => 'ChangeArmor',

      #     [int(Actor ID)]---[int:{0:Add, 1:Remove}]---[int:{0:NO, 1:YES}(Initialize)]---END
      129 => 'ChangePartyMember',

      #     [RPG::BGM]---END
      132 => 'ChangeBattleBGM',

      #     [RPG::ME]---END
      133 => 'ChangeBattleEndME',

      #     [int:{0:Disable, 1:Enable}]---END
      134 => 'ChangeSaveAccess',

      #     [int:{0:Disable, 1:Enable}]---END
      135 => 'ChangeMenuAccess',

      #     [int:{0:Disable, 1:Enable}]---END
      136 => 'ChangeEncounter',

      #     [int:{0:Disable, 1:Enable}]---END
      137 => 'ChangeFormationAccess',

      #     [RPG::Tone]---END
      138 => 'ChangeWindowColor',

      #     |--[int:0(Direct Designation)]---[int(Map ID)]---[int(Map X)]---[int(Map Y)]-------------------------------------------------------------------------------------|
      #     |                                                                                                                                                                |--[int:{0:Retain, 2:Down, 4:Left, 6:Right, 8:Up}(Direction)]---[int:{0:Normal, 1:White, 2:None}(Fade)]---END
      #     |--[int:1(Designation with Variables)]---[int(Map ID Corresponded Variable ID)]---[int(Map X Corresponded Variable ID)]---[int(Map Y Corresponded Variable ID)]--|
      201 => 'TransferPlayer',

      #                                        |--[int:0(Direct Designation)]---[int(Map ID)]---[int(Map X)]---[int(Map Y)]---END
      #     [int:{0:Boat, 1:Ship, 2:Airship}]--|
      #                                        |--[int:1(Designation with Variables)]---[int(Map ID Corresponded Variable ID)]---[int(Map X Corresponded Variable ID)]---[int(Map Y Corresponded Variable ID)]---END
      202 => 'SetVehicleLocation',

      #                                                 |--[int:0(Direct Designation)]---[int(Map X)]---[int(Map Y)]------------------------------------------------------------|
      #                                                 |                                                                                                                       |
      #     [int:{0:This Event, 1:EV001, ...}]----------|--[int:1(Designation with Variables)]---[int(Map X Corresponded Variable ID)]---[int(Map Y Corresponded Variable ID)]--|--[int:{0:Retain, 2:Down, 4:Left, 6:Right, 8:Up}(Direction)]---END
      #                                                 |                                                                                                                       |
      #                                                 |--[int:2(Exchange with Another Event)]---[int(Exchanged Event ID)]---[int:0]-------------------------------------------|
      203 => 'SetEventLocation',

      #     [int:{2:Down, 4:Left, 6:Right, 8:Up}]---[int:{0~100}(Distance)]---[int:{1:1/8 Speed, 2:1/4 Speed, 3:1/2 Speed, 4:Normal, 5:2 Speed, 6:4 Speed}]---END
      204 => 'ScrollMap',

      #     [int:{-1:Player, 0:This Event, 1:EV001, ...}]---[RPG::MoveRoute(45 is Script)]---END
      205 => 'SetMoveRoute',

      #     END
      206 => 'GetSwitchVehicle',

      #     [int:{0:ON, 1:OFF}]---END
      211 => 'ChangeTransparency',

      #     [int:{-1:Player, 0:This Event, 1:EV001, ...}]---[int(Animation ID)]---[bool(Wait for Completion)]---END
      212 => 'ShowAnimation',

      #     [int:{-1:Player, 0:This Event, 1:EV001, ...}]---[int(Ballon Icon ID)]---[bool(Wait for Completion)]---END
      213 => 'ShowBalloonIcon',
      214 => 'EraseEvent',

      #     [int:{0:ON, 1:OFF}]---END
      216 => 'ChangePlayerFollowers',
      217 => 'GatherFollowers',
      221 => 'FadeoutScreen',
      222 => 'FadeinScreen',

      #     [RPG::Tone]---[int:{0~600}(Time 1/60 sec)]---[bool(Wait for Completion)]---END
      223 => 'TintScreen',

      #     [RPG::Color]---[int:{0~600}(Time 1/60 sec)]---[bool(Wait for Completion)]---END
      224 => 'FlashScreen',

      #     [int:{1~9}(Power)]---[int:{1~9}(Speed)]---[int:{0~600}(Time 1/60 sec)]---[bool(Wait for Completion)]---END
      225 => 'ShakeScreen',

      #     [int:{0~999}(Time 1/60 sec)]---END
      230 => 'Wait',

      #                                                                                                      |--[int:0(Constant)]---[int:{-9999~9999}(Map X)]---[int:{-9999~9999}(Map Y)]--------------------------|
      #     [int:{1~100}(Number)]---[string(Picture Graphic Name)]---[int:{0:Upper Left, 1:Center}(Origin)]--|                                                                                                     |--[int:{0~2000}(Width %)]---[int:{0~2000}(Height %)]---[int:{0~255}(Opacity)]---[int:{0:Normal, 1:Add, 2:Sub}]---END
      #                                                                                                      |--[int:1(Variable)]---[int(Map X Corresponded Variable ID)]---[int(Map Y Corresponded Variable ID)]--|
      231 => 'ShowPicture',

      #                                                                     |--[int:0(Constant)]---[int:{-9999~9999}(Map X)]---[int:{-9999~9999}(Map Y)]--------------------------|
      #     [int:{1~100}(Number)]---[int:{0:Upper Left, 1:Center}(Origin)]--|                                                                                                     |--[int:{0~2000}(Width %)]---[int:{0~2000}(Height %)]---[int:{0~255}(Opacity)]---[int:{0:Normal, 1:Add, 2:Sub}]---[int:{0~600}(Time 1/60 sec)]---[bool(Wait for Completion)]---END
      #                                                                     |--[int:1(Variable)]---[int(Map X Corresponded Variable ID)]---[int(Map Y Corresponded Variable ID)]--|
      232 => 'MovePicture',

      #     [int:{1~100}(Number)]-[int:{-90~90}(Speed)]--END
      233 => 'RotatePicture',

      #     [int:{1~100}(Number)]---[RPG::Tone]---[int:{0~600}(Time 1/60 sec)]---[bool(Wait for Completion)]---END
      234 => 'TintPicture',

      #     [int:{1~100}(Number)]---END
      235 => 'ErasePicture',

      #     [string:{":none", ":rain", ":storm", ":snow"}]---[int:{0~9}(Power)]---[int:{0~600}(Time 1/60 sec)]---[bool(Wait for Completion)]---END
      236 => 'SetWeatherEffects',

      #     [RPG::BGM]---END
      241 => 'PlayBGM',

      #     [int:{1~60}(Time sec)]---END
      242 => 'FadeoutBGM',
      243 => 'SaveBGM',
      244 => 'ReplayBGM',

      #     [RPG::BGM]---END
      245 => 'PlayBGS',

      #     [int:{1~60}(Time sec)]---END
      246 => 'FadeoutBGS',

      #     [RPG::ME]---END
      249 => 'PlayME',

      #     [RPG::SE]---END
      250 => 'PlaySE',
      251 => 'StopSE',

      #     [string(Movie Name)]---END
      261 => 'PlayMovie',

      #     [int:{0:ON, 1:OFF}]---END
      281 => 'ChangeMapNameDisplay',

      #     [int(Tileset ID)]---END
      282 => 'ChangeTileset',

      #     [string(Floor Picture)]---[string(Wall Picture)]---END
      283 => 'ChangeBattleBack',

      #     [string(Distant view Picture)]---[bool(Loop Horizontal)]---[bool(Loop Vertical)]---[int(-32~32)(Horizontal Scroll)]---[int(-32~32)(Vertical Scrool)]---END
      284 => 'ChangeParallaxBack',

      #                                                                                                                                                   |--[int:0(Direct Designation)]---[int(Map X)]---[int(Map Y)]---END
      #     [int(Variable for Info)]---[int:{0:Terrain, 1:Event ID, 2:Tile ID(Layer 1), 3:Tile ID(Layer 2), 4:Tile ID(Layer 3), 5:Region ID}(Info Type)]--|
      #                                                                                                                                                   |--[int:1(Designation with Variables)]---[int(Map X Corresponded Variable ID)]---[int(Map Y Corresponded Variable ID)]---END
      285 => 'GetLocationInfo',

      #     |--[int:0(Direct Designation)]---[int(Enemy ID)]-----------------------------------|
      #     |                                                                                  |--[bool(Can Escape)]---[bool(Continue Even When Loser)]---END
      #     |--[int:1(Designation with Variables)]---[int(Enemy ID Corresponded Variable ID)]--|
      301 => 'BattleProcessing',

      #                                                                      |--[int:0(Price: Standard)]---[int:0]------------------|
      #     [int:{0:Item, 1:Weapon, 2:Armor}]---[int(Corresponded Item ID)]--|                                                      |--[bool(Purchase Only)]---END
      #                                                                      |--[int:1(Price: Specify)]---[int:{0~9999999}(Price)]--|
      302 => 'ShopProcessing',

      #     [int(Actor ID)]---[int:{1~16}(Max Characters)]---END
      303 => 'NameInputProcessing',

      #                                                                                         |--[int:0(Constant)]---[int:{1~9999}(Number)]--|
      #                                                                   |--[int:0(Increase)]--|                                              |--[bool:false(Allow Knockout)]---END
      #                                                                   |                     |--[int:1(Variable)]---[int(Variable ID)]------|
      #     |--[int:0(Fixed)]---[int:{0:Entire Party, 1:Actor 001, ...}]--|
      #     |                                                             |                     |--[int:0(Constant)]---[int:{1~9999}(Number)]--|
      #     |                                                             |--[int:1(Decrease)]--|                                              |--[bool(Allow Knockout)]---END
      #     |                                                                                   |--[int:1(Variable)]---[int(Variable ID)]------|
      #     |
      #     |                                                                                     |--[int:0(Constant)]---[int:{1~9999}(Number)]--|
      #     |                                                               |--[int:0(Increase)]--|                                              |--[bool:false(Allow Knockout)]---END
      #     |                                                               |                     |--[int:1(Variable)]---[int(Variable ID)]------|
      #     |--[int:1(Variable)]---[int(Variable ID)]-----------------------|
      #                                                                     |                     |--[int:0(Constant)]---[int:{1~9999}(Number)]--|
      #                                                                     |--[int:1(Decrease)]--|                                              |--[bool(Allow Knockout)]---END
      #                                                                                           |--[int:1(Variable)]---[int(Variable ID)]------|
      311 => 'ChangeHP',

      #     |--[int:0(Fixed)]---[int:{0:Entire Party, 1:Actor 001, ...}]--|                                  |--[int:0(Constant)]---[int:{1~9999}(Number)]---END
      #     |                                                             |--[int:{0:Increase, 1:Decrease}]--|
      #     |--[int:1(Variable)]---[int(Variable ID)]---------------------|                                  |--[int:1(Variable)]---[int(Variable ID)]---END
      312 => 'ChangeMP',

      #     |--[int:0(Fixed)]---[int:{0:Entire Party, 1:Actor 001, ...}]--|
      #     |                                                             |--[int:{0:Add, 1:Remove}]---[int(State ID)]---END
      #     |--[int:1(Variable)]---[int(Variable ID)]---------------------|
      313 => 'ChangeState',

      #     |--[int:0(Fixed)]---[int:{0:Entire Party, 1:Actor 001, ...}]---END
      #     |
      #     |--[int:1(Variable)]---[int(Variable ID)]---END
      314 => 'RecoverAll',

      #                                                                                         |--[int:0(:Constant)]---[int:{1~9999999}(Number)]--|
      #                                                                   |--[int:0(Increase)]--|                                                  |--[bool(Show Level Up Message)]---END
      #                                                                   |                     |--[int:1(Variable)]---[int(Variable ID)]----------|
      #     |--[int:0(Fixed)]---[int:{0:Entire Party, 1:Actor 001, ...}]--|
      #     |                                                             |                     |--[int:0(Constant)]---[int:{1~9999999}(Number)]--|
      #     |                                                             |--[int:1(Decrease)]--|                                                 |--[bool:false(Show Level Up Message)]---END
      #     |                                                                                   |--[int:1(Variable)]------------------------------|
      #     |
      #     |                                                                                   |--[int:0(Constant)]---[int:{1~9999999}(Number)]--|
      #     |                                                             |--[int:0(Increase)]--|                                                 |--[bool(Show Level Up Message)]---END
      #     |                                                             |                     |--[int:1(Variable)]---[int(Variable ID)]---------|
      #     |--[int:1(Variable)]---[int(Variable ID)]---------------------|
      #                                                                   |                     |--[int:0(Constant)]---[int:{1~9999999}(Number)]--|
      #                                                                   |--[int:1(Decrease)]--|                                                 |--[bool:false(Show Level Up Message)]---END
      #                                                                                         |--[int:1(Variable)]---[int(Variable ID)]---------|
      315 => 'ChangeEXP',

      #                                                                                         |--[int:0(Constant)]---[int:{1~98}(Number)]--|
      #                                                                   |--[int:0(Increase)]--|                                            |--[bool(Show Level Up Message)]---END
      #                                                                   |                     |--[int:1(Variable)]---[int(Variable ID)]----|
      #     |--[int:0(Fixed)]---[int:{0:Entire Party, 1:Actor 001, ...}]--|
      #     |                                                             |                     |--[int:0(Constant)]---[int:{1~98}(Number)]--|
      #     |                                                             |--[int:1(Decrease)]--|                                            |--[bool:false(Show Level Up Message)]---END
      #     |                                                                                   |--[int:1(Variable)]---[int(Variable ID)]----|
      #     |
      #     |                                                                                   |--[int:0(Constant)]---[int:{1~98}(Number)]--|
      #     |                                                             |--[int:0(Increase)]--|                                            |--[bool(Show Level Up Message)]---END
      #     |                                                             |                     |--[int:1(Variable)]---[int(Variable ID)]----|
      #     |--[int:1(Variable)]---[int(Variable ID)]---------------------|
      #                                                                   |                     |--[int:0(Constant)]---[int:{1~98}(Number)]--|
      #                                                                   |--[int:1(Decrease)]--|                                            |--[bool:false(Show Level Up Message)]---END
      #                                                                                       |--[int:1(Variable)]---[int(Variable ID)]------|
      316 => 'ChangeLevel',

      #     |--[int:0(Fixed)]---[int:{0:Entire Party, 1:Actor 001, ...}]--|                                                                                                   |--[int:0(Constant)]---[int:{0~9999999}(Number)]---END
      #     |                                                             |--[int:{0:MHP, 1:MMP, 2:ATK, 3:DEF, 4:MAT, 5:MDF, 6:AGI, 7:LUK}]---[int:{0:Increase, 1:Decrease}]--|
      #     |--[int:1(Variable)]---[int(Variable ID)]---------------------|                                                                                                   |--[int:1(Variable)]---[int(Variable ID)]---END
      317 => 'ChangeParameters',

      #     |--[int:0(Fixed)]---[int:{0:Entire Party, 1:Actor 001, ...}]--|
      #     |                                                             |--[int:{0:Learn, 1:Forget}]---[int(Skill ID)]---END
      #     |--[int:1(Variable)]---[int(Variable ID)]---------------------|
      318 => 'ChangeSkills',

      #     [int(Actor ID)]---[int:{0:Weapon, 1:Shield, 2:Head, 3:Boby, 4:Accessory}]---[int:{0:None, 1:Equipment 001, ...}(Equipment ID)]---END
      319 => 'ChangeEquipment',

      #     [int(Actor ID)]---[string(New Actor Name)]---END
      320 => 'ChangeActorName',

      #     [int(Actor ID)]---[int(New Class ID)]---END
      321 => 'ChangeActorClass',

      #     [int(Actor ID)]---[string(New Actor walking Picture Name)]---[int(New Actor Walking Picture Index)]---[string(New Actor Portrait Picture Name)]---[int(New Actor Portrait Picture Index)]---END
      322 => 'ChangeActorGraphic',

      #     [int:{0:Boat, 1:Ship, 2:Airship}]---[string(New Vehicle Picture Name)]---[int(New Vehicle Picture Index)]---END
      323 => 'ChangeVehicleGraphic',

      #     [int(Actor ID)]---[string(New Actor Nickname)]---END
      324 => 'ChangeActorNickname',

      #                                                                      |--[int:0(Constant)]---[int:{1~999999}(Number)]--|
      #                                                |--[int:0(Increase)]--|                                                |--[bool:false(Allow Knockout)]---END
      #                                                |                     |--[int:1(Variable)]---[int(Variable ID)]--------|
      #     [int:{-1:Entire Troop, 0:Troop 001, ...}]--|
      #                                                |                     |--[int:0(Constant)]---[int:{1~999999}(Number)]--|
      #                                                |--[int:1(Decrease)]--|                                                |--[bool(Allow Knockout)]---END
      #                                                                      |--[int:1(Variable)]---[int(Variable ID)]--------|
      #
      331 => 'ChangeEnemyHP',

      #                                                                                 |--[int:0(Constant)]---[int:{1~9999}(Number)]---END
      #     [int:{-1:Entire Troop, 0:Troop 001, ...}]---[int:{0:Increase, 1:Decrease}]--|
      #                                                                                 |--[int:1(Variable)]---[int(Variable ID)]---END
      332 => 'ChangeEnemyMP',

      #     [int:{-1:Entire Troop, 0:Troop 001, ...}]---[int:{0:Add, 1:Remove}]---[int(State ID)]---END
      333 => 'ChangeEnemyState',

      #     [int:{-1:Entire Troop, 0:Troop 001, ...}]---END
      334 => 'EnemyRecoverAll',

      #     [int:{-1:Entire Troop, 0:Troop 001, ...}]---END
      335 => 'EnemyAppear',

      #     [int(Troop ID)]---[int(Enemy ID)]---END
      336 => 'EnemyTransform',

      #     [int:{-1:Entire Troop, 0:Troop 001, ...}]---[int(Animation ID)]---END
      337 => 'ShowBattleAnimation',

      #     |--[int:0(Enemy)]---[int(Troop ID)]--|
      #     |                                    |--[int(Skill ID)]---[int:{-2:Last Target, -1:Random, 0:Index 1,...}]---END
      #     |--[int:1(Actor)]---[int(Actor ID)]--|
      339 => 'ForceAction',
      340 => 'AbortBattle',
      351 => 'OpenMenuScreen',
      352 => 'OpenSaveScreen',
      353 => 'GameOver',
      354 => 'ReturnToTitleScreen',

      #     [string]---END
      355 => 'Script',

      #     [string]---END
      401 => 'ShowText',

      #     [int(Choice Index)]---[string(Choice Name)]---END
      402 => 'When',
      403 => 'WhenCancel',
      404 => 'ChoicesEnd',

      #     [string]---END
      405 => 'ShowScrollingText',

      #     [string]---END
      408 => 'CommentMore',
      411 => 'Else',
      412 => 'BranchEnd',
      413 => 'RepeatAbove',

      #     [RPG::MoveCommand(45 is script)]---END
      505 => 'MoveRoute',
      601 => 'IfWin',
      602 => 'IfEscape',
      603 => 'IfLose',
      604 => 'BattleProcessingEnd',

      #                                                                      |--[int:0(Price: Standard)]---[int:0]---END
      #     [int:{0:Item, 1:Weapon, 2:Armor}]---[int(Corresponded Item ID)]--|
      #                                                                      |--[int:1(Price: Specify)]---[int:{0~9999999}(Price)]---END
      605 => 'ShopItem',

      #     [string]---END
      655 => 'ScriptMore'
    }.freeze

    # 红色
    RED_COLOR = "\e[31m"

    # 绿色
    GREEN_COLOR = "\e[32m"

    # 黄色
    YELLOW_COLOR = "\e[33m"

    # 蓝色
    BLUE_COLOR = "\e[34m"

    # 紫色
    MAGENTA_COLOR = "\e[35m"

    # 青色
    CYAN_COLOR = "\e[36m"

    # 重置颜色
    RESET_COLOR = "\e[0m"

    # 清除行
    ESCAPE = "\e[2K"

    # 根据 file_basename 检查 object 的类型在 module_name 中是否正确
    #
    # @param object [Object] 待检查的对象
    # @param file_basename [String] 文件名（不包含扩展名）
    # @param is_compact [Boolean] 是否为紧凑模式
    # @param module_name [Symbol] 模块名
    #
    # @raise [RPGTypeError] object 的类型不在 RPG 模块中
    # @raise [R3EXSTypeError] object 的类型不在 R3EXS 模块中
    # @raise [ModuleNameError] module_name 不是 :RPG 或 :R3EXS
    # @raise [FileBaseNameError] file_basename 无法匹配到对应的类
    #
    # @return [void]
    def self.check_type(object, file_basename, is_compact, module_name)
      case module_name
      when :RPG
        matched_class = FILE_BASENAME_TO_CLASS_RPG.find { |pattern, _| file_basename =~ pattern }&.last
        matched_class or raise FileBaseNameError.new(file_basename), "Invalid file basename: #{file_basename}"
        if object.is_a?(Array)
          items = is_compact ? object.compact : object
          items.all? { |item| item.is_a?(matched_class) } or raise RPGTypeError.new(object), "Invalid Object: #{object}, it's not an Array<#{matched_class}>"
        elsif object.is_a?(Hash)
          values = is_compact ? object.compact.values : object.values
          values.all? { |item| item.is_a?(matched_class) } or raise RPGTypeError.new(object), "Invalid Object: #{object}, it's not a Hash<#{matched_class}>"
        else
          object.is_a?(matched_class) or raise RPGTypeError.new(object), "Invalid Object: #{object}, it's not a #{matched_class}"
        end
      when :R3EXS
        matched_class = FILE_BASENAME_TO_CLASS_R3EXS.find { |pattern, _| file_basename =~ pattern }&.last
        matched_class or raise FileBaseNameError.new(file_basename), "Invalid file basename: #{file_basename}"
        if object.is_a?(Array)
          items = is_compact ? object.compact : object
          items.all? { |item| item.is_a?(matched_class) } or raise R3EXSTypeError.new(object), "Invalid object: #{object}, it's not an Array<#{matched_class}>"
        elsif object.is_a?(Hash)
          values = is_compact ? object.compact.values : object.values
          values.all? { |item| item.is_a?(matched_class) } or raise R3EXSTypeError.new(object), "Invalid object: #{object}, it's not a Hash<#{matched_class}>"
        else
          object.is_a?(matched_class) or raise R3EXSTypeError.new(object), "Invalid object: #{object}, it's not #{matched_class}"
        end
      else
        raise ModuleNameError.new(module_name), "Invalid module name: #{module_name}"
      end
    end

    # 将 RPG 中的对象转化为 R3EXS 对象
    #
    # @param object [Object] 待转化的 RPG 对象
    # @param file_basename [String] 文件名（不包含扩展名）
    # @param with_notes [Boolean] 是否包含注释
    #
    # @raise [RPGTypeError] object 的类型不在 RPG 模块中
    # @raise [FileBaseNameError] file_basename 无法匹配到对应的类
    #
    # @return [Object]
    def self.rpg_r3exs(object, file_basename, with_notes)
      check_type(object, file_basename, true, :RPG)

      # 首先根据 file_basename 找到对应的类
      matched_class = Utils::FILE_BASENAME_TO_CLASS_R3EXS.find { |pattern, _| file_basename =~ pattern }.last

      # 然后根据 object 的类型进行处理
      # 如果 object 是数组，则遍历数组，对每个元素进行处理
      # 如果 object 是哈希，则遍历哈希，对每个值进行处理
      # 如果 object 是其他类型，则直接处理
      if object.is_a?(Array)
        temp = []
        object.each_with_index do |obj, index|
          next if obj.nil?

          obj_r3exs = matched_class.new(obj, index, with_notes)
          temp << obj_r3exs unless obj_r3exs.empty?
        end
      elsif object.is_a?(Hash) # 只有 RPG::MapInfo 是 Hash，且 key 为整数
        temp = []
        object.each do |key, obj|
          next if obj.nil?

          temp << matched_class.new(obj, key, with_notes)
        end
      else
        # 只有 RPG::Map 和 RPG::System 是单独一个对象，且不可能为 nil
        temp = matched_class.new(object, with_notes)
      end
      temp
    end

    # 读取 target_dir 下的所有 rvdata2 文件，将其反序列化为对象，并调用 block
    #
    # @note 注意传入 block 的 object
    #       - 如果 object 是数组或哈希，则其中可能存在 nil 元素
    #       - 如果 object 是单独一个对象，则不可能为 nil
    #
    # @param target_dir [Pathname] 目标目录
    #
    # @yieldparam object [Object] rvdata2 文件反序列化后的对象
    # @yieldparam file_basename [String] 文件名（不包含扩展名）
    # @yieldparam parent_relative_dir [Pathname] 文件所在目录的相对路径
    # @yieldreturn [void]
    #
    # @raise [Rvdata2FileError] rvdata2 文件可能损坏
    # @raise [Rvdata2DirError] target_dir 不存在
    #
    # @return [void]
    def self.all_rvdata2_files(target_dir)
      # 检查 target_dir 目录是否存在
      target_dir.exist? && target_dir.directory? or raise Rvdata2DirError.new(target_dir.to_s), "rvdata2 directory not found: #{target_dir}"
      # 递归获取 target_dir 下的所有 *.rvdata2 文件
      target_dir.glob('**/*.rvdata2').each do |file_path|
        file_basename = file_path.basename('.rvdata2').to_s
        # 检查文件名是否在 RVDATA2_FILE_NAME 中与其正则表达式匹配
        next unless RVDATA2_FILE_NAME.any? { |pattern| file_basename =~ pattern }

        if $global_options[:verbose]
          print "#{ESCAPE}#{BLUE_COLOR}Reading and Deserializing from #{RESET_COLOR}#{file_path}...\r"
        end
        object = Marshal.load(file_path.binread)

        # 如果文件名不是 'Scripts'，则检查 object 的类型是否正确
        unless file_basename == 'Scripts'
          # 检查 object 的类型是否正确
          # 这里的类型检查要用紧凑模式，因为 rvdata2 文件中可能存在 nil 元素，必须忽略
          begin
            check_type(object, file_basename, true, :RPG)
          rescue RPGTypeError
            raise Rvdata2FileError.new(file_path.to_s), "Invalid rvdata2 file: #{file_path}"
          end
        end

        yield object, file_basename, file_path.dirname.relative_path_from(target_dir)
      end
    end

    # 读取 target_dir 下的所有常规 JSON 文件，将其反序列化为对象，并调用 block
    #
    # @note 注意传入 block 的 object
    #       - 在 module_name 为 RPG 时，如果 object 是数组或哈希，则其中可能存在 nil 元素。如果 object 是单独一个对象，则不可能为 nil
    #       - 在 module_name 为 R3EXS 时，object 不会为 nil
    #
    # @param target_dir [Pathname] 目标目录
    # @param module_name [Symbol] 模块名
    #
    # @yieldparam object [Object] JSON 文件反序列化后的对象
    # @yieldparam file_basename [String] 文件名（不包含扩展名）
    # @yieldparam parent_relative_dir [Pathname] 文件所在目录的相对路径
    # @yieldreturn [void]
    #
    # @raise [RPGJsonFileError] json 文件不是 RPG 模块中的对象
    # @raise [R3EXSJsonFileError] json 文件不是 R3EXS 模块中的对象
    # @raise [ModuleNameError] module_name 不是 :RPG 或 :R3EXS
    # @raise [JsonDirError] target_dir 不存在
    #
    # @return [void]
    def self.all_json_files(target_dir, module_name)
      # 检查 target_dir 目录是否存在
      target_dir.exist? && target_dir.directory? or raise JsonDirError.new(target_dir.to_s), "JSON directory not found: #{target_dir}"
      # 递归获取 target_dir 下的所有 *.json 文件
      target_dir.glob('**/*.json').each do |file_path|
        file_basename = file_path.basename('.json').to_s
        # 检查文件名是否在 JSON_FILE_NAME 中与其正则表达式匹配
        next unless JSON_FILE_NAME.any? { |pattern| file_basename =~ pattern }

        if $global_options[:verbose]
          print "#{ESCAPE}#{BLUE_COLOR}Reading and Deserializing #{RESET_COLOR}#{file_path}...\r"
        end
        object = Oj.load_file(file_path.to_s)

        case module_name
        when :RPG
          # 这里的类型检查要用紧凑模式，因为这是从 rvdata2 文件直接全部序列化后的 JSON 文件中读取的 object，其中可能存在 nil 元素
          begin
            check_type(object, file_basename, true, module_name)
          rescue RPGTypeError
            raise RPGJsonFileError.new(file_path.to_s), "Invalid RPG JSON file: #{file_path}"
          end
        when :R3EXS
          # 这里的类型检查不能用紧凑模式，因为这是从 R3EXS 模块的类序列化后的 JSON 文件中读取的 object，程序设计中不应该存在 nil 元素
          begin
            check_type(object, file_basename, false, module_name)
          rescue R3EXSTypeError
            raise R3EXSJsonFileError.new(file_path.to_s), "Invalid R3EXS JSON file: #{file_path}"
          end
        else
          raise ModuleNameError.new(module_name), "Invalid module name: #{module_name}"
        end

        yield object, file_basename, file_path.dirname.relative_path_from(target_dir)
      end
    end

    # 读取 target_dir 下的所有 CommonEvent JSON 文件，将其反序列化为对象数组，并调用 block
    #
    # @note 注意传入 block 的 object
    #       - 在 module_name 为 RPG 时，object 可能存在 nil 元素
    #       - 在 module_name 为 R3EXS 时，object 不可能存在 nil 元素
    #
    # @param target_dir [Pathname] 目标目录
    # @param module_name [Symbol] 模块名
    #
    # @yieldparam commonevents [Array<Object>] CommonEvent JSON 文件反序列化后的数组
    # @yieldparam commonevents_basenames [Array<String>] CommonEvent JSON 文件名数组（不包含扩展名）
    # @yieldparam parent_relative_dir [Pathname] 文件所在目录的相对路径
    # @yieldreturn [void]
    #
    # @raise [RPGJsonFileError] json 文件不是 RPG 模块中的对象
    # @raise [R3EXSJsonFileError] json 文件不是 R3EXS 模块中的对象
    # @raise [ModuleNameError] module_name 不是 :RPG 或 :R3EXS
    # @raise [JsonDirError] target_dir 不存在
    #
    # @return [void]
    def self.all_commonevent_json_files(target_dir, module_name)
      # 检查 target_dir 目录是否存在
      target_dir.exist? && target_dir.directory? or raise JsonDirError.new(target_dir.to_s), "JSON directory not found: #{target_dir}"

      # 用两个个Hash来存储每一个父目录下的所有的 CommonEvent_\d{5}.json 文件的反序列化后的对象数组以及其文件名数组
      # Hash 的键是父目录的路径，值是一个数组，存储该目录下的所有 CommonEvent_\d{5}.json 文件的反序列化后的对象数组以及其文件名数组
      commonevents_hash = Hash.new { |h, k| h[k] = [] }
      commonevents_basenames_hash = Hash.new { |h, k| h[k] = [] }

      # 递归获取 target_dir 下的所有 CommonEvent_\d{5}.json 文件
      target_dir.glob('**/CommonEvent_[0-9][0-9][0-9][0-9][0-9].json').each do |file_path|
        if $global_options[:verbose]
          print "#{ESCAPE}#{BLUE_COLOR}Reading and Deserializing #{RESET_COLOR}#{file_path}...\r"
        end
        object = Oj.load_file(file_path.to_s)
        parent_dir = file_path.dirname
        commonevents_hash[parent_dir] << object
        commonevents_basenames_hash[parent_dir] << file_path.basename('.json').to_s
      end

      # 遍历每一个父目录的路径
      commonevents_hash.each_key do |parent_dir|
        commonevents = commonevents_hash[parent_dir]
        commonevents_basenames = commonevents_basenames_hash[parent_dir]

        case module_name
        when :RPG
          # 这里的类型检查要用紧凑模式，因为这是从 rvdata2 文件直接全部序列化后的 JSON 文件中读取的 object，其中可能存在 nil 元素
          begin
            check_type(commonevents, 'CommonEvents', true, module_name)
          rescue RPGTypeError
            raise RPGJsonFileError.new(parent_dir.to_s), 'Invalid RPG CommonEvents JSON file'
          end
        when :R3EXS
          # 这里的类型检查不能用紧凑模式，因为这是从 R3EXS 模块的类序列化后的 JSON 文件中读取的 object，程序设计中不应该存在 nil 元素
          begin
            check_type(commonevents, 'CommonEvents', false, module_name)
          rescue R3EXSTypeError
            raise R3EXSJsonFileError.new(parent_dir.to_s), 'Invalid R3EXS CommonEvents JSON file'
          end
        else
          raise ModuleNameError.new(module_name), "Invalid module name: #{module_name}"
        end

        yield commonevents, commonevents_basenames, parent_dir.relative_path_from(target_dir)
      end
    end

    # 读取 target_dir 下的所有 Ruby 源码文件，并调用 block
    #
    # @note 注意这里以二进制方式读取文件，因为 Prism 里面的节点的位置是相对二进制下的位置
    #
    # @param target_dir [Pathname] 目标目录
    #
    # @yieldparam scripts [Array<String>] 读取的 Ruby 源码文件数组
    # @yieldparam scripts_basenames [Array<String>] Ruby 源码文件名数组（不包含扩展名）
    # @yieldparam parent_relative_dir [Pathname] 文件所在目录的相对路径
    # @yieldreturn [void]
    #
    # @raise [JsonDirError] target_dir 不存在
    #
    # @return [void]
    def self.all_rb_files(target_dir)
      # 检查 target_dir 目录是否存在
      target_dir.exist? && target_dir.directory? or raise JsonDirError.new(target_dir.to_s), "JSON directory not found: #{target_dir}"

      # 用两个个Hash来存储每一个父目录下的所有的 \d{3}.rb 文件的反序列化后的对象数组以及其文件名数组
      # Hash 的键是父目录的路径，值是一个数组，存储该目录下的所有 \d{3}.rb 文件的反序列化后的对象数组以及其文件名数组
      scripts_hash = Hash.new { |h, k| h[k] = [] }
      scripts_basenames_hash = Hash.new { |h, k| h[k] = [] }

      # 递归获取 target_dir 下的所有 \d{5}.rb 文件
      target_dir.glob('**/[0-9][0-9][0-9].rb').each do |file_path|
        if $global_options[:verbose]
          print "#{ESCAPE}#{BLUE_COLOR}Reading and Deserializing #{RESET_COLOR}#{file_path}...\r"
        end
        object = file_path.binread
        parent_dir = file_path.dirname
        scripts_hash[parent_dir] << object
        scripts_basenames_hash[parent_dir] << file_path.basename('.rb').to_s
      end

      # 遍历每一个父目录的路径
      scripts_hash.each_key do |parent_dir|
        scripts = scripts_hash[parent_dir]
        scripts_basenames = scripts_basenames_hash[parent_dir]
        yield scripts, scripts_basenames, parent_dir.relative_path_from(target_dir)
      end
    end

    # 将 object 序列化为 json 文件
    #
    # @param object [Object] 待序列化的对象
    # @param output_file [Pathname] 输出文件路径
    #
    # @return [void]
    def self.object_json(object, output_file)
      output_file.dirname.mkpath unless output_file.dirname.exist?
      output_file.write(Oj.dump(object, indent: 2))
    end

    # 将 object 序列化为 rvdata2 文件
    #
    # @param object [Object] 待序列化的对象
    # @param output_file [Pathname] 输出文件路径
    #
    # @return [void]
    def self.object_rvdata2(object, output_file)
      output_file.dirname.mkpath unless output_file.dirname.exist?
      output_file.binwrite(Marshal.dump(object))
    end
  end
end
