# frozen_string_literal: true

module R3EXS
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
    #     |                                          |--[int:4(Weapon)]---[int(Weapon ID)]---END
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

    #     [string(Distant view Picture)]---[bool(Loop Horizontal)]---[bool(Loop Vertical)]---[int(-32~32)(Horizontal Scroll)]---[int(-32~32)(Vertical Scroll)]---END
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
  # 地图数据类
  class Map
    # 地图显示名
    #
    # @return [String]
    attr_accessor :display_name

    # 备注
    #
    # @return [String]
    attr_accessor :note

    # 地图事件
    #
    # @return [Hash{Integer => R3EXS::Event}]
    attr_accessor :events

    # 用 RPG::Map 初始化
    #
    # @param map [RPG::Map] 待处理的 RPG::Map 对象
    #
    # @return [R3EXS::Map]
    def initialize(map)
      @display_name = map.display_name
      @note = map.note
      @events = {}
      map.events.each do |key, event|
        next if event.nil?

        event_r3exs = R3EXS::Event.new(event)
        @events[key] = event_r3exs unless event_r3exs.empty?
      end
    end

    # 注入到 RPG::Map 对象
    #
    # @param map [RPG::Map] 待注入的 RPG::Map 对象
    #
    # @return [void]
    def inject_to(map)
      map.display_name = @display_name
      map.note = @note
      @events.each { |key, event| event.inject_to(map.events[key]) }
    end

    # 提取所有的字符串
    #
    # @return [Array<String>]
    def ex_strings
      strings = [@display_name]
      strings << @note
      @events.each_value { |event| strings.concat(event.ex_strings) }
      strings
    end

    # 将所有的字符串替换为指定的字符串
    #
    # @param hash [Hash{String => String}] 字符串翻译表
    #
    # @return [void]
    def in_strings(hash)
      @display_name = hash.fetch(@display_name, @display_name)
      @note = hash.fetch(@note, @note)
      @events.each_value { |event| event.in_strings(hash) }
    end
  end

  # 地图信息的数据类
  class MapInfo
    # 地图名称
    #
    # @return [String]
    attr_accessor :name

    # 用 RPG::MapInfo 初始化
    #
    # @param mapinfo [RPG::MapInfo] 待处理的 RPG::MapInfo 对象
    #
    # @return [R3EXS::MapInfo]
    def initialize(mapinfo)
      @name = mapinfo.name
    end

    # 注入到 RPG::MapInfo 对象
    #
    # @param mapinfo [RPG::MapInfo] 待注入的 RPG::MapInfo 对象
    #
    # @return [void]
    def inject_to(mapinfo)
      mapinfo.name = @name
    end

    # 提取所有的字符串
    #
    # @return [Array<String>]
    def ex_strings
      [@name]
    end

    # 将所有的字符串替换为指定的字符串
    #
    # @param hash [Hash{String => String}] 字符串翻译表
    #
    # @return [void]
    def in_strings(hash)
      @name = hash.fetch(@name, @name)
    end

    # 判断是否为空
    #
    # @return [Boolean]
    def empty?
      @name.blank?
    end
  end

  # 地图事件的数据类
  class Event
    # 名称
    #
    # @return [String]
    attr_accessor :name

    # 事件页数组
    #
    # @return [Array<R3EXS::Event::Page>]
    attr_accessor :pages

    # 用 RPG::Event 初始化
    #
    # @param event [RPG::Event] 待处理的 RPG::Event 对象
    #
    # @return [R3EXS::Event]
    def initialize(event)
      @name = event.name
      @pages = []
      event.pages.each_with_index do |page, page_index|
        next if page.nil?

        page_r3exs = R3EXS::Event::Page.new(page, page_index)
        @pages << page_r3exs unless page_r3exs.empty?
      end
    end

    # 注入到 RPG::Event 对象
    #
    # @param event [RPG::Event] 待注入的 RPG::Event 对象
    #
    # @return [void]
    def inject_to(event)
      event.name = @name
      @pages.each { |page| page.inject_to(event.pages[page.index]) }
    end

    # 提取所有的字符串
    #
    # @return [Array<String>]
    def ex_strings
      strings = [@name]
      @pages.each { |page| strings.concat(page.ex_strings) }
      strings
    end

    # 将所有的字符串替换为指定的字符串
    #
    # @param hash [Hash{String => String}] 字符串翻译表
    #
    # @return [void]
    def in_strings(hash)
      @name = hash.fetch(@name, @name)
      @pages.each { |page| page.in_strings(hash) }
    end

    # 判断是否为空
    #
    # @return [Boolean]
    def empty?
      @name.blank? && @pages.empty?
    end

    # 地图事件块事件页资料
    class Page
      # 在原始数组中的索引
      #
      # @return [Integer]
      attr_accessor :index

      # 执行内容
      #
      # @return [Array<R3EXS::EventCommand>]
      attr_accessor :list

      # 用 RPG::Event::Page 初始化
      #
      # @param page [RPG::Event::Page] 待处理的 RPG::Event::Page 对象
      # @param index [Integer] 在原始数组中的索引
      #
      # @return [R3EXS::Event::Page]
      def initialize(page, index)
        @index = index
        @list = []
        page.list.each_with_index do |eventcommand, eventcommand_index|
          next if eventcommand.nil?

          eventcommand_r3exs = R3EXS::EventCommand.new(eventcommand, eventcommand_index)
          @list << eventcommand_r3exs unless eventcommand_r3exs.empty?
        end
      end

      # 注入到 RPG::Event::Page 对象
      #
      # @param page [RPG::Event::Page] 待注入的 RPG::Event::Page 对象
      #
      # @return [void]
      def inject_to(page)
        @list.each { |eventcommand| eventcommand.inject_to(page.list[eventcommand.index]) }
      end

      # 提取所有的字符串
      #
      # @return [Array<String>]
      def ex_strings
        strings = []
        @list.each { |eventcommand| strings.concat(eventcommand.ex_strings) }
        strings
      end

      # 将所有的字符串替换为指定的字符串
      #
      # @param hash [Hash{String => String}] 字符串翻译表
      #
      # @return [void]
      def in_strings(hash)
        @list.each { |eventcommand| eventcommand.in_strings(hash) }
      end

      # 判断是否为空
      #
      # @return [Boolean]
      def empty?
        @list.empty?
      end
    end
  end

  # 事件指令的数据类
  class EventCommand
    # 在原始数组中的索引
    #
    # @return [Integer]
    attr_accessor :index

    # 事件指令代码
    #
    # @return [Integer]
    attr_accessor :code

    # 事件指令用途
    #
    # @return [String]
    attr_accessor :usage

    # 事件指令参数
    #
    # @return [Array<String, R3EXS::MoveRoute>]
    attr_accessor :parameter

    # 用 RPG::EventCommand 初始化
    #
    # @param eventcommand [RPG::EventCommand] 待处理的 RPG::EventCommand 对象
    # @param index [Integer] 在原始数组中的索引
    #
    # @return [R3EXS::EventCommand]
    def initialize(eventcommand, index)
      @index = index
      @code = eventcommand.code
      @parameter = []
      case @code
      when 102 # ShowChoices
        @usage = EVENT_COMMANDS[102]
        @parameter.concat(eventcommand.parameters[0])
      when 108 # Comment
        @usage = EVENT_COMMANDS[108]
        @parameter << eventcommand.parameters[0]
      when 111 # ConditionalBranch
        @usage = EVENT_COMMANDS[111]
        if eventcommand.parameters[0] == 4 && eventcommand.parameters[2] == 1
          @parameter << eventcommand.parameters[3]
        elsif eventcommand.parameters[0] == 12
          @parameter << eventcommand.parameters[1]
        end
      when 118 # Label
        @usage = EVENT_COMMANDS[118]
        @parameter << eventcommand.parameters[0]
      when 119 # JumpToLabel
        @usage = EVENT_COMMANDS[119]
        @parameter << eventcommand.parameters[0]
      when 122 # ControlVariables
        if eventcommand.parameters[3] == 4
          @usage = EVENT_COMMANDS[122]
          @parameter << eventcommand.parameters[4]
        end
      when 205 # SetMoveRoute
        moveroute_r3exs = R3EXS::MoveRoute.new(eventcommand.parameters[1])
        unless moveroute_r3exs.empty?
          @usage = EVENT_COMMANDS[205]
          @parameter << moveroute_r3exs
        end
      when 320 # ChangeActorName
        @usage = EVENT_COMMANDS[320]
        @parameter << eventcommand.parameters[1]
      when 324 # ChangeActorNickname
        @usage = EVENT_COMMANDS[324]
        @parameter << eventcommand.parameters[1]
      when 355 # Script
        @usage = EVENT_COMMANDS[355]
        @parameter << eventcommand.parameters[0]
      when 401 # ShowText
        @usage = EVENT_COMMANDS[401]
        @parameter << eventcommand.parameters[0]
      when 402 # When
        @usage = EVENT_COMMANDS[402]
        @parameter << eventcommand.parameters[1]
      when 405 # ShowScrollingText
        @usage = EVENT_COMMANDS[405]
        @parameter << eventcommand.parameters[0]
      when 408 # CommentMore
        @usage = EVENT_COMMANDS[408]
        @parameter << eventcommand.parameters[0]
      when 655 # ScriptMore
        @usage = EVENT_COMMANDS[655]
        @parameter << eventcommand.parameters[0]
      end
    end

    # 注入到 RPG::EventCommand 对象
    #
    # @param eventcommand [RPG::EventCommand] 待注入的 RPG::EventCommand 对象
    #
    # @return [void]
    def inject_to(eventcommand)
      case eventcommand.code
      when 102 # ShowChoices
        eventcommand.parameters[0] = @parameter
      when 108 # Comment
        eventcommand.parameters[0] = @parameter[0]
      when 111 # ConditionalBranch
        if eventcommand.parameters[0] == 4 && eventcommand.parameters[2] == 1
          eventcommand.parameters[3] = @parameter[0]
        elsif eventcommand.parameters[0] == 12
          eventcommand.parameters[1] = @parameter[0]
        end
      when 118 # Label
        eventcommand.parameters[0] = @parameter[0]
      when 119 # JumpToLabel
        eventcommand.parameters[0] = @parameter[0]
      when 122 # ControlVariables
        eventcommand.parameters[4] = @parameter[0]
      when 205 # SetMoveRoute
        @parameter[0].inject_to(eventcommand.parameters[1])
      when 320 # ChangeActorName
        eventcommand.parameters[1] = @parameter[0]
      when 324 # ChangeActorNickname
        eventcommand.parameters[1] = @parameter[0]
      when 355 # Script
        eventcommand.parameters[0] = @parameter[0]
      when 401 # ShowText
        eventcommand.parameters[0] = @parameter[0]
      when 402 # When
        eventcommand.parameters[1] = @parameter[0]
      when 405 # ShowScrollingText
        eventcommand.parameters[0] = @parameter[0]
      when 408 # CommentMore
        eventcommand.parameters[0] = @parameter[0]
      when 655 # ScriptMore
        eventcommand.parameters[0] = @parameter[0]
      end
    end

    # 提取所有的字符串
    #
    # @return [Array<String>]
    def ex_strings
      strings = []
      if @code == 205
        strings.concat(@parameter[0].ex_strings)
      else
        strings.concat(@parameter)
      end
      strings
    end

    # 将所有的字符串替换为指定的字符串
    #
    # @param hash [Hash{String => String}] 字符串翻译表
    #
    # @return [void]
    def in_strings(hash)
      if @code == 205
        @parameter[0].in_strings(hash)
      else
        @parameter.map! { |string| hash.fetch(string, string) }
      end
    end

    # 判断是否为空
    #
    # @return [Boolean]
    def empty?
      @parameter.empty?
    end
  end

  # 移动路线的数据类
  class MoveRoute
    # 移动路线内容
    #
    # @return [Array<R3EXS::MoveCommand>]
    attr_accessor :list

    # 用 RPG::MoveRoute 初始化
    #
    # @param moveroute [RPG::MoveRoute] 待处理的 RPG::MoveRoute 对象
    #
    # @return [R3EXS::MoveRoute]
    def initialize(moveroute)
      @list = []
      moveroute.list.each_with_index do |movecommand, index|
        next if movecommand.nil?

        movecommand_r3exs = R3EXS::MoveCommand.new(movecommand, index)
        @list << movecommand_r3exs unless movecommand_r3exs.empty?
      end
    end

    # 注入到 RPG::MoveRoute 对象
    #
    # @param moveroute [RPG::MoveRoute] 待注入的 RPG::MoveRoute 对象
    #
    # @return [void]
    def inject_to(moveroute)
      @list.each { |movecommand| movecommand.inject_to(moveroute.list[movecommand.index]) }
    end

    # 提取所有的字符串
    #
    # @return [Array<String>]
    def ex_strings
      strings = []
      @list.each { |movecommand| strings.concat(movecommand.ex_strings) }
      strings
    end

    # 将所有的字符串替换为指定的字符串
    #
    # @param hash [Hash{String => String}] 字符串翻译表
    #
    # @return [void]
    def in_strings(hash)
      @list.each { |movecommand| movecommand.in_strings(hash) }
    end

    # 判断是否为空
    #
    # @return [Boolean]
    def empty?
      @list.empty?
    end
  end

  # 移动路线指令的数据类
  class MoveCommand
    # 在原始数组中的索引
    #
    # @return [Integer]
    attr_accessor :index

    # 移动路线指令代码
    #
    # @return [Integer]
    attr_accessor :code

    # 移动指令用途
    #
    # @return [String]
    attr_accessor :usage

    # 移动指令参数
    #
    # @return [Array<String>]
    attr_accessor :parameter

    # 用 RPG::MoveCommand 初始化
    #
    # @param movecommand [RPG::MoveCommand] 待处理的 RPG::MoveCommand 对象
    # @param index [Integer] 在原始数组中的索引
    #
    # @return [R3EXS::MoveCommand]
    def initialize(movecommand, index)
      @index = index
      @code = movecommand.code
      @parameter = []
      return unless @code == 45

      @usage = 'MoveCommandScript'
      @parameter << movecommand.parameters[0]
    end

    # 注入到 RPG::MoveCommand 对象
    #
    # @param movecommand [RPG::MoveCommand] 待注入的 RPG::MoveCommand 对象
    #
    # @return [void]
    def inject_to(movecommand)
      return unless movecommand.code == 45

      movecommand.parameters[0] = @parameter[0]
    end

    # 提取所有的字符串
    #
    # @return [Array<String>]
    def ex_strings
      @parameter
    end

    # 将所有的字符串替换为指定的字符串
    #
    # @param hash [Hash{String => String}] 字符串翻译表
    #
    # @return [void]
    def in_strings(hash)
      @parameter.map! { |string| hash.fetch(string, string) }
    end

    # 判断是否为空
    #
    # @return [Boolean]
    def empty?
      @parameter.empty?
    end
  end

  # 角色、职业、技能、物品、武器、护甲、敌人和状态的超类
  class BaseItem
    # 在原始数组中的索引
    #
    # @return [Integer]
    attr_reader :index

    # 名称
    #
    # @return [String]
    attr_accessor :name

    # 说明
    #
    # @return [String]
    attr_accessor :description

    # 备注
    #
    # @return [String]
    attr_accessor :note

    # 用 RPG::BaseItem 初始化
    #
    # @param baseitem [RPG::BaseItem] 待处理的 RPG::BaseItem 对象
    # @param index [Integer] 在原始数组中的索引
    #
    # @return [R3EXS::BaseItem]
    def initialize(baseitem, index)
      @index = index
      @name = baseitem.name
      @description = baseitem.description
      @note = baseitem.note
    end

    # 注入到 RPG::BaseItem 对象
    #
    # @param baseitem [RPG::BaseItem] 待注入的 RPG::BaseItem 对象
    #
    # @return [void]
    def inject_to(baseitem)
      baseitem.name = @name
      baseitem.description = @description
      baseitem.note = @note
    end

    # 提取所有的字符串
    #
    # @return [Array<String>]
    def ex_strings
      strings = []
      strings << @name
      strings << @description
      strings << @note
      strings
    end

    # 将所有的字符串替换为指定的字符串
    #
    # @param hash [Hash{String => String}] 字符串翻译表
    #
    # @return [void]
    def in_strings(hash)
      @name = hash.fetch(@name, @name)
      @description = hash.fetch(@description, @description)
      @note = hash.fetch(@note, @note)
    end

    # 判断是否为空
    #
    # @return [Boolean]
    def empty?
      @name.blank? && @description.blank? && @note.blank?
    end
  end

  # 角色的数据类
  class Actor < BaseItem
    # 称号
    #
    # @return [String]
    attr_accessor :nickname

    # 用 RPG::Actor 初始化
    #
    # @param actor [RPG::Actor] 待处理的 RPG::Actor 对象
    # @param index [Integer] 在原始数组中的索引
    #
    # @return [R3EXS::Actor]
    def initialize(actor, index)
      super(actor, index)
      @nickname = actor.nickname
    end

    # 注入到 RPG::Actor 对象
    #
    # @param actor [RPG::Actor] 待注入的 RPG::Actor 对象
    #
    # @return [void]
    def inject_to(actor)
      super(actor)
      actor.nickname = @nickname
    end

    # 提取所有的字符串
    #
    # @return [Array<String>]
    def ex_strings
      strings = super
      strings << @nickname
      strings
    end

    # 将所有的字符串替换为指定的字符串
    #
    # @param hash [Hash{String => String}] 字符串翻译表
    #
    # @return [void]
    def in_strings(hash)
      super(hash)
      @nickname = hash.fetch(@nickname, @nickname)
    end

    # 判断是否为空
    #
    # @return [Boolean]
    def empty?
      super && @nickname.blank?
    end
  end

  # 职业的数据类
  class Class < BaseItem
    # 习得技能
    #
    # @return [Array<R3EXS::Class::Learning>]
    attr_accessor :learnings

    # 用 RPG::Class 初始化
    #
    # @param klass [RPG::Class] 待处理的 RPG::Class 对象
    # @param index [Integer] 在原始数组中的索引
    #
    # @return [R3EXS::Class]
    def initialize(klass, index)
      super(klass, index)
      @learnings = []
      klass.learnings.each_with_index do |learning, learning_index|
        next if learning.nil?

        learning_r3exs = R3EXS::Class::Learning.new(learning, learning_index)
        @learnings << learning_r3exs unless learning_r3exs.empty?
      end
    end

    # 注入到 RPG::Class 对象
    #
    # @param klass [RPG::Class] 待注入的 RPG::Class 对象
    #
    # @return [void]
    def inject_to(klass)
      super(klass)
      @learnings.each { |learning| learning.inject_to(klass.learnings[learning.index]) }
    end

    # 提取所有的字符串
    #
    # @return [Array<String>]
    def ex_strings
      strings = super
      @learnings.each { |learning| strings.concat(learning.ex_strings) }
      strings
    end

    # 将所有的字符串替换为指定的字符串
    #
    # @param hash [Hash{String => String}] 字符串翻译表
    #
    # @return [void]
    def in_strings(hash)
      super(hash)
      @learnings.each { |learning| learning.in_strings(hash) }
    end

    # 判断是否为空
    #
    # @return [Boolean]
    def empty?
      super && @learnings.empty?
    end

    # 职业[技能]的数据类
    class Learning
      # 在原始数组中的索引
      #
      # @return [Integer]
      attr_reader :index

      # 备注
      #
      # @return [String]
      attr_accessor :note

      # 用 RPG::Class::Learning 初始化
      #
      # @param learning [RPG::Class::Learning] 待处理的 RPG::Class::Learning 对象
      # @param index [Integer] 在原始数组中的索引
      #
      # @return [R3EXS::Class::Learning]
      def initialize(learning, index)
        @index = index
        @note = learning.note
      end

      # 注入到 RPG::Class::Learning 对象
      #
      # @param learning [RPG::Class::Learning] 待注入的 RPG::Class::Learning 对象
      #
      # @return [void]
      def inject_to(learning)
        learning.note = @note
      end

      # 提取所有的字符串
      #
      # @return [Array<String>]
      def ex_strings
        [@note]
      end

      # 将所有的字符串替换为指定的字符串
      #
      # @param hash [Hash{String => String}] 字符串翻译表
      #
      # @return [void]
      def in_strings(hash)
        @note = hash.fetch(@note, @note)
      end

      # 判断是否为空
      #
      # @return [Boolean]
      def empty?
        @note.blank?
      end
    end
  end

  # 技能和物品的超类
  class UsableItem < BaseItem
  end

  # 技能的数据类
  class Skill < UsableItem
    # 使用时的信息
    #
    # @return [String]
    attr_accessor :message1

    # 使用时的信息
    #
    # @return [String]
    attr_accessor :message2

    # 用 RPG::Skill 初始化
    #
    # @param skill [RPG::Skill] 待处理的 RPG::Skill 对象
    # @param index [Integer] 在原始数组中的索引
    #
    # @return [R3EXS::Skill]
    def initialize(skill, index)
      super(skill, index)
      @message1 = skill.message1
      @message2 = skill.message2
    end

    # 注入到 RPG::Skill 对象
    #
    # @param skill [RPG::Skill] 待注入的 RPG::Skill 对象
    #
    # @return [void]
    def inject_to(skill)
      super
      skill.message1 = @message1
      skill.message2 = @message2
    end

    # 提取所有的字符串
    #
    # @return [Array<String>]
    def ex_strings
      strings = super
      strings << @message1
      strings << @message2
      strings
    end

    # 将所有的字符串替换为指定的字符串
    #
    # @param hash [Hash{String => String}] 字符串翻译表
    #
    # @return [void]
    def in_strings(hash)
      super(hash)
      @message1 = hash.fetch(@message1, @message1)
      @message2 = hash.fetch(@message2, @message2)
    end

    # 判断是否为空
    #
    # @return [Boolean]
    def empty?
      super && @message1.blank? && @message2.blank?
    end
  end

  # 物品的数据类
  class Item < UsableItem
  end

  # 武器与护甲的超类
  class EquipItem < BaseItem
  end

  # 武器的数据类
  class Weapon < EquipItem
  end

  # 护甲的数据类
  class Armor < EquipItem
  end

  # 敌人的数据类
  class Enemy < BaseItem
  end

  # 状态的数据类
  class State < BaseItem
    # 状态提示信息, 附加到队友
    #
    # @return [String]
    attr_accessor :message1

    # 状态提示信息, 附加到敌人
    #
    # @return [String]
    attr_accessor :message2

    # 状态提示信息, 状态持续
    #
    # @return [String]
    attr_accessor :message3

    # 状态提示信息, 状态解除
    #
    # @return [String]
    attr_accessor :message4

    # 用 RPG::State 初始化
    #
    # @param state [RPG::State] 待处理的 RPG::State 对象
    # @param index [Integer]  在原始数组中的索引
    #
    # @return [R3EXS::State]
    def initialize(state, index)
      super(state, index)
      @message1 = state.message1
      @message2 = state.message2
      @message3 = state.message3
      @message4 = state.message4
    end

    # 注入到 RPG::State 对象
    #
    # @param state [RPG::State] 待注入的 RPG::State 对象
    #
    # @return [void]
    def inject_to(state)
      super
      state.message1 = @message1
      state.message2 = @message2
      state.message3 = @message3
      state.message4 = @message4
    end

    # 提取所有的字符串
    #
    # @return [Array<String>]
    def ex_strings
      strings = super
      strings << @message1
      strings << @message2
      strings << @message3
      strings << @message4
      strings
    end

    # 将所有的字符串替换为指定的字符串
    #
    # @param hash [Hash{String => String}] 字符串翻译表
    #
    # @return [void]
    def in_strings(hash)
      super(hash)
      @message1 = hash.fetch(@message1, @message1)
      @message2 = hash.fetch(@message2, @message2)
      @message3 = hash.fetch(@message3, @message3)
      @message4 = hash.fetch(@message4, @message4)
    end

    # 判断是否为空
    #
    # @return [Boolean]
    def empty?
      super && @message1.blank? && @message2.blank? && @message3.blank? && @message4.blank?
    end
  end

  # 敌人队伍的数据类
  class Troop
    # 在原始数组中的索引
    #
    # @return [Integer]
    attr_accessor :index

    # 敌人队伍名称
    #
    # @return [String]
    attr_accessor :name

    # 战斗事件
    #
    # @return [Array<R3EXS::Troop::Page>]
    attr_accessor :pages

    # 用 RPG::Troop 初始化
    #
    # @param troop [RPG::Troop] 待处理的 RPG::Troop 对象
    # @param index [Integer] 在原始数组中的索引
    #
    # @return [R3EXS::Troop]
    def initialize(troop, index, _unused = nil)
      @index = index
      @name = troop.name
      @pages = []
      troop.pages.each_with_index do |page, page_index|
        next if page.nil?

        page_r3exs = R3EXS::Troop::Page.new(page, page_index)
        @pages << page_r3exs unless page_r3exs.empty?
      end
    end

    # 注入到 RPG::Troop 对象
    #
    # @param troop [RPG::Troop] 待注入的 RPG::Troop 对象
    #
    # @return [void]
    def inject_to(troop)
      troop.name = @name
      @pages.each { |page| page.inject_to(troop.pages[page.index]) }
    end

    # 提取所有的字符串
    #
    # @return [Array<String>]
    def ex_strings
      strings = [@name]
      @pages.each { |page| strings.concat(page.ex_strings) }
      strings
    end

    # 将所有的字符串替换为指定的字符串
    #
    # @param hash [Hash{String => String}] 字符串翻译表
    #
    # @return [void]
    def in_strings(hash)
      @name = hash.fetch(@name, @name)
      @pages.each { |page| page.in_strings(hash) }
    end

    # 判断是否为空
    #
    # @return [Boolean]
    def empty?
      @name.blank? && @pages.empty?
    end

    # 战斗事件（页）的数据类
    class Page
      # 在原始数组中的索引
      #
      # @return [Integer]
      attr_accessor :index

      # 执行内容
      #
      # @return [Array<R3EXS::EventCommand>]
      attr_accessor :list

      # 用 RPG::Troop::Page 初始化
      #
      # @param page [RPG::Troop::Page] 待处理的 RPG::Troop::Page 对象
      # @param index [Integer] 在原始数组中的索引
      #
      # @return [R3EXS::Troop::Page]
      def initialize(page, index)
        @index = index
        @list = []
        page.list.each_with_index do |eventcommand, eventcommand_index|
          next if eventcommand.nil?

          eventcommand_r3exs = R3EXS::EventCommand.new(eventcommand, eventcommand_index)
          @list << eventcommand_r3exs unless eventcommand_r3exs.empty?
        end
      end

      # 注入到 RPG::Troop::Page 对象
      #
      # @param page [RPG::Troop::Page] 待注入的 RPG::Troop::Page 对象
      #
      # @return [void]
      def inject_to(page)
        @list.each { |eventcommand| eventcommand.inject_to(page.list[eventcommand.index]) }
      end

      # 提取所有的字符串
      #
      # @return [Array<String>]
      def ex_strings
        strings = []
        @list.each { |eventcommand| strings.concat(eventcommand.ex_strings) }
        strings
      end

      # 将所有的字符串替换为指定的字符串
      #
      # @param hash [Hash{String => String}] 字符串翻译表
      #
      # @return [void]
      def in_strings(hash)
        @list.each { |eventcommand| eventcommand.in_strings(hash) }
      end

      # 判断是否为空
      #
      # @return [Boolean]
      def empty?
        @list.empty?
      end
    end
  end

  # 动画的数据类
  class Animation
    # 在原始数组中的索引
    #
    # @return [Integer]
    attr_reader :index

    # 名称
    #
    # @return [String]
    attr_accessor :name

    # 用 RPG::Animation 初始化
    #
    # @param animation [RPG::Animation] 待处理的 RPG::Animation 对象
    # @param index [Integer] 在原始数组中的索引
    #
    # @return [R3EXS::Animation]
    def initialize(animation, index, _unused = nil)
      @index = index
      @name = animation.name
    end

    # 注入到 RPG::Animation 对象
    #
    # @param animation [RPG::Animation] 待注入的 RPG::Animation 对象
    #
    # @return [void]
    def inject_to(animation)
      animation.name = @name
    end

    # 提取所有的字符串
    #
    # @return [Array<String>]
    def ex_strings
      [@name]
    end

    # 将所有的字符串替换为指定的字符串
    #
    # @param hash [Hash{String => String}] 字符串翻译表
    #
    # @return [void]
    def in_strings(hash)
      @name = hash.fetch(@name, @name)
    end

    # 判断是否为空
    #
    # @return [Boolean]
    def empty?
      @name.blank?
    end
  end

  # 图块的数据类
  class Tileset
    # 在原始数组中的索引
    #
    # @return [Integer]
    attr_accessor :index

    # 图块页名称
    #
    # @return [String]
    attr_accessor :name

    # 备注
    #
    # @return [String]
    attr_accessor :note

    # 用 RPG::Tileset 初始化
    #
    # @param tileset [RPG::Tileset] 待处理的 RPG::Tileset 对象
    # @param index [Integer] 在原始数组中的索引
    #
    # @return [R3EXS::Tileset]
    def initialize(tileset, index)
      @index = index
      @name = tileset.name
      @note = tileset.note
    end

    # 注入到 RPG::Tileset 对象
    #
    # @param tileset [RPG::Tileset] 待注入的 RPG::Tileset 对象
    #
    # @return [void]
    def inject_to(tileset)
      tileset.name = @name
      tileset.note = @note
    end

    # 提取所有的字符串
    #
    # @return [Array<String>]
    def ex_strings
      strings = [@name]
      strings << @note
      strings
    end

    # 将所有的字符串替换为指定的字符串
    #
    # @param hash [Hash{String => String}] 字符串翻译表
    #
    # @return [void]
    def in_strings(hash)
      @name = hash.fetch(@name, @name)
      @note = hash.fetch(@note, @note)
    end

    # 判断是否为空
    #
    # @return [Boolean]
    def empty?
      @name.blank? && @note.blank?
    end
  end

  # 公共事件的数据类
  class CommonEvent
    # 在原始数组中的索引
    #
    # @return [Integer]
    attr_accessor :index

    # 名称
    #
    # @return [String]
    attr_accessor :name

    # 执行内容
    #
    # @return [Array<R3EXS::EventCommand>]
    attr_accessor :list

    # 用 RPG::CommonEvent 初始化
    #
    # @param commonevent [RPG::CommonEvent] 待处理的 RPG::CommonEvent 对象
    # @param index [Integer] 在原始数组中的索引
    #
    # @return [R3EXS::CommonEvent]
    def initialize(commonevent, index, _unused = nil)
      @index = index
      @name = commonevent.name
      @list = []
      commonevent.list.each_with_index do |eventcommand, eventcommand_index|
        next if eventcommand.nil?

        eventcommand_r3exs = R3EXS::EventCommand.new(eventcommand, eventcommand_index)
        @list << eventcommand_r3exs unless eventcommand_r3exs.empty?
      end
    end

    # 注入到 RPG::CommonEvent 对象
    #
    # @param commonevent [RPG::CommonEvent] 待注入的 RPG::CommonEvent 对象
    #
    # @return [void]
    def inject_to(commonevent)
      commonevent.name = @name
      @list.each { |eventcommand| eventcommand.inject_to(commonevent.list[eventcommand.index]) }
    end

    # 提取所有的字符串
    #
    # @return [Array<String>]
    def ex_strings
      strings = [@name]
      @list.each { |eventcommand| strings.concat(eventcommand.ex_strings) }
      strings
    end

    # 将所有的字符串替换为指定的字符串
    #
    # @param hash [Hash{String => String}] 字符串翻译表
    #
    # @return [void]
    def in_strings(hash)
      @name = hash.fetch(@name, @name)
      @list.each { |eventcommand| eventcommand.in_strings(hash) }
    end

    # 判断是否为空
    #
    # @return [Boolean]
    def empty?
      @name.blank? && @list.empty?
    end
  end

  # 系统的数据类
  class System
    # 游戏标题
    #
    # @return [String]
    attr_accessor :game_title

    # 货币单位
    #
    # @return [String]
    attr_accessor :currency_unit

    # 属性列表
    #
    # @return [Array<String>]
    attr_accessor :elements

    # 技能类型列表
    #
    # @return [Array<String>]
    attr_accessor :skill_types

    # 武器类型列表
    #
    # @return [Array<String>]
    attr_accessor :weapon_types

    # 护甲类型列表
    #
    # @return [Array<String>]
    attr_accessor :armor_types

    # 开关列表
    #
    # @return [Array<String>]
    attr_accessor :switches

    # 变量列表
    #
    # @return [Array<String>]
    attr_accessor :variables

    # 用语
    #
    # @return [R3EXS::System::Terms]
    attr_accessor :terms

    # 用 RPG::System 初始化
    #
    # @param system [RPG::System] 待处理的 RPG::System 对象
    #
    # @return [R3EXS::System]
    def initialize(system, _unused = nil)
      @game_title = system.game_title
      @currency_unit = system.currency_unit
      @elements = system.elements
      @skill_types = system.skill_types
      @weapon_types = system.weapon_types
      @armor_types = system.armor_types
      @switches = system.switches
      @variables = system.variables
      @terms = R3EXS::System::Terms.new(system.terms)
    end

    # 注入到 RPG::System 对象
    #
    # @param system [RPG::System] 待注入的 RPG::System 对象
    #
    # @return [void]
    def inject_to(system)
      system.game_title = @game_title
      system.currency_unit = @currency_unit
      system.elements = @elements
      system.skill_types = @skill_types
      system.weapon_types = @weapon_types
      system.armor_types = @armor_types
      system.switches = @switches
      system.variables = @variables
      @terms.inject_to(system.terms)
    end

    # 提取所有的字符串
    #
    # @return [Array<String>]
    def ex_strings
      strings = [@game_title]
      strings << @currency_unit
      strings.concat(@elements)
      strings.concat(@skill_types)
      strings.concat(@weapon_types)
      strings.concat(@armor_types)
      strings.concat(@switches)
      strings.concat(@variables)
      strings.concat(@terms.ex_strings)
      strings
    end

    # 将所有的字符串替换为指定的字符串
    #
    # @param hash [Hash{String => String}] 字符串翻译表
    #
    # @return [void]
    def in_strings(hash)
      @game_title = hash.fetch(@game_title, @game_title)
      @currency_unit = hash.fetch(@currency_unit, @currency_unit)
      @elements.map! { |string| hash.fetch(string, string) }
      @skill_types.map! { |string| hash.fetch(string, string) }
      @weapon_types.map! { |string| hash.fetch(string, string) }
      @armor_types.map! { |string| hash.fetch(string, string) }
      @switches.map! { |string| hash.fetch(string, string) }
      @variables.map! { |string| hash.fetch(string, string) }
      @terms.in_strings(hash)
    end

    # 用语的资料类
    class Terms
      # 基本状态
      #
      # @return [Array<String>]
      attr_accessor :basic

      # 能力
      #
      # @return [Array<String>]
      attr_accessor :params

      # 装备位置
      #
      # @return [Array<String>]
      attr_accessor :etypes

      # 指令
      #
      # @return [Array<String>]
      attr_accessor :commands

      # 用 RPG::System::Terms 初始化
      #
      # @param terms [RPG::System::Terms] 待处理的 RPG::System::Terms 对象
      #
      # @return [R3EXS::System::Terms]
      def initialize(terms)
        @basic = terms.basic
        @params = terms.params
        @etypes = terms.etypes
        @commands = terms.commands
      end

      # 注入到 RPG::System::Terms 对象
      #
      # @param terms [RPG::System::Terms] 待注入的 RPG::System::Terms 对象
      #
      # @return [void]
      def inject_to(terms)
        terms.basic = @basic
        terms.params = @params
        terms.etypes = @etypes
        terms.commands = @commands
      end

      # 提取所有的字符串
      #
      # @return [Array<String>]
      def ex_strings
        strings = @basic
        strings.concat(@params)
        strings.concat(@etypes)
        strings.concat(@commands)
        strings
      end

      # 将所有的字符串替换为指定的字符串
      #
      # @param hash [Hash{String => String}] 字符串翻译表
      #
      # @return [void]
      def in_strings(hash)
        @basic.map! { |string| hash.fetch(string, string) }
        @params.map! { |string| hash.fetch(string, string) }
        @etypes.map! { |string| hash.fetch(string, string) }
        @commands.map! { |string| hash.fetch(string, string) }
      end
    end
  end
end
