EVENT_COMMANDS = {
    0 => "空语句",

    # 角色肖像图:string
    # 角色肖像图索引:int
    # 窗口背景:int (0:普通窗口, 1:暗色窗口, 2:透明窗口)
    # 显示位置:int (0:居上, 1:居中, 2:居下)
    101 => "显示文章",

    # 选项名数组:Array<string>
    # 取消的时候:int (0:无, 1:第一个选项, 2:第二个选项, 3:第三个选项, 4:第四个选项, 5:分支)
    102 => "显示选项",

    # 接受数值的变量:int
    # 位数:int (1~8)
    103 => "数值输入处理",

    # 接受物品ID的变量:int
    104 => "物品选择处理",

    # 速度:int (1~8)
    # 禁止快进:bool
    105 => "显示滚动文字",

    # 注释:string
    108 => "注释",

    # 操作数1来源:int (0:开关, 1:变量, 2:独立开关, 3:计时器, 4:角色, 5:敌人, 6:人物, 7:金钱, 8:物品, 9:武器, 10:护甲, 11:按钮, 12:脚本, 13:乘坐)
    #       操作数1来源为0时:
    #               开关ID:int
    #               开关状态:int (0:开启, 1:关闭)
    #       操作数1来源为1时:
    #               变量ID:int
    #               操作符:int (0:等于, 1:不小于, 2:不大于, 3:大于, 4:小于, 5:不等于)
    #               操作数2来源:int(0:常量, 1:变量)
    #               操作数2:int
    #       操作数1来源为2时:
    #               独立开关的名称:string('A', 'B', 'C', 'D')
    #               开关状态:int (0:开启, 1:关闭)
    #       操作数1来源为3时:
    #               时间:int(单位: sec, 范围: 0~5999)
    #               操作符:int(0:不小于, 1:不大于)
    #       操作数1来源为4时:
    #               角色ID:int
    #               角色属性:int(0:在队伍时, 1.名称为, 2.职业是, 3.技能, 4.武器, 5.护甲, 6.状态是)
    #                       角色属性为1时:
    #                               名称:string
    #                       角色属性为2时:
    #                               职业ID:int
    #                       角色属性为3时:
    #                               技能ID:int(技能已经学会时)
    #                       角色属性为4时:
    #                               武器ID:int(武器已经装备时)
    #                       角色属性为5时:
    #                               护甲ID:int(护甲已经装备时)
    #                       角色属性为6时:
    #                               状态ID:int
    #       操作数1来源为5时:
    #               敌队ID:int(0:1号敌人..., 7:8号敌人)
    #               操作符:int(0:已经存在, 1:状态是)
    #                       操作符为1时:
    #                               状态ID:int
    #       操作数1来源为6时:
    #               人物ID:int (-1:玩家, 0: 本事件, 1: EV001事件...)
    #               朝向:int (2:向下, 4:向左, 6:向右, 8:向上)
    #       操作数1来源为7时:
    #               持有金钱:int(0~9999999)
    #               操作符:int(0:不小于, 1:不大于, 2:小于)
    #       操作数1来源为8时:
    #               物品ID:int(持有时)
    #       操作数1来源为9时:
    #               武器ID:int(持有时)
    #               包含已装备的:bool
    #       操作数1来源为10时:
    #               护甲ID:int(持有时)
    #               包含已装备的:bool
    #       操作数1来源为11时:
    #               按钮ID:int(2:下, 4:左, 6:右, 8:上, 11:A, 12:B, 13:C, 14:X, 15:Y, 16:Z, 17:R, 18:L)
    #       操作数1来源为12时:
    #               脚本:string
    #       操作数1来源为13时:
    #               载具类型:int
    111 => "如果_分支",
    112 => "循环_开始",
    113 => "跳出",
    115 => "中止事件处理",

    # 事件ID:int
    117 => "公共事件",

    # 标签:string
    118 => "标签",

    # 目标标签:string
    119 => "转至标签",

    # 开关起始:int
    # 开关终止:int
    # 操作:int (0:开启, 1:关闭)
    121 => "开关操作",

    # 变量起始:int
    # 变量终止:int
    # 操作:int (0:赋值, 1:加法, 2:减法, 3:乘法, 4:除法, 5:取余)
    # 数据来源:int (0:常量, 1:变量, 2:随机数, 3:数据, 4:脚本)
    #       数据来源为2时:
    #               随机数最小值:int
    #               随机数最大值:int
    #       数据来源为3时:
    #               数据来源分类:int (0:物品, 1:武器, 2:护甲, 3:角色, 4:敌人, 5:人物, 6:队伍, 7:其他)
    #               数据来源分类为0~2时:
    #                       数据来源的对应分类的物品ID:int(实际数据为对应ID的物品的持有数)
    #               数据来源分类为3时:
    #                       数据来源的角色的ID:int
    #                       数据来源的角色的参数:int (0:等级, 1:经验值, 2:体力值, 3:魔力值, 4:体力上限, 5:魔力上限, 6:物理攻击, 7:物理防御, 8:魔法攻击, 9:魔法防御, 10:敏捷值, 11:幸运值)
    #               数据来源分类为4时:
    #                       数据来源的敌队的ID:int(0:1号敌人..., 7:8号敌人)
    #                       数据来源的敌人的参数:int (0:体力值, 1:魔力值, 2:体力上限, 3:魔力上限, 4:物理攻击, 5:物理防御, 6:魔法攻击, 7:魔法防御, 8:敏捷值, 9:幸运值)
    #               数据来源分类为5时:
    #                       数据来源的人物的ID:int (-1:玩家, 0: 本事件, 1: EV001事件...)
    #                       数据来源的人物的参数:int (0:地图X, 1:地图Y, 2:方向, 3:画面X, 4:画面Y)
    #               数据来源分类为6时:
    #                       数据来源的队伍的参数:int (0:第1个队员, 1:第2个队员, ... , 7:第8个队员)(实际数据为对应队员的ID)
    #               数据来源分类为7时:
    #                       数据来源的其他的参数:int (0:地图ID, 1:队伍人数, 2:持有金钱, 3:步数, 4:游戏时间, 5:计时器, 6:存档次数, 7:战斗次数)
    #       数据来源为4时:
    #               脚本:string
    122 => "变量操作",

    # 独立开关的名称:string('A', 'B', 'C', 'D')
    # 操作:int (0:开启, 1:关闭)
    123 => "独立开关操作",

    # 计时器操作:int (0:启动, 1:停止)
    # 时间:int(单位: sec, 范围: 0~5999)
    124 => "计时器操作",

    # 操作:int (0:增加, 1:减少)
    # 数值来源:int (0:常量, 1:变量)
    # 数值:int
    125 => "增减金钱",

    # 物品ID:int
    # 操作:int (0:增加, 1:减少)
    # 数值来源:int (0:常量, 1:变量)
    # 数值:int
    126 => "增减物品",

    # 武器ID:int
    # 操作:int (0:增加, 1:减少)
    # 数值来源:int (0:常量, 1:变量)
    # 数值:int
    # 包含已装备的:bool
    127 => "增减武器",

    # 护甲ID:int
    # 操作:int (0:增加, 1:减少)
    # 数值来源:int (0:常量, 1:变量)
    # 数值:int
    # 包含已装备的:bool
    128 => "增减护甲",

    # 角色ID:int
    # 操作:int (0:增加, 1:减少)
    # 初始化角色数据:int (0:不初始化, 1:初始化)
    129 => "队伍管理",

    # 战斗背景音乐:RPG::BGM
    132 => "更改战斗背景音乐",

    # 战斗结束音效:RPG::ME
    133 => "更改战斗结束音效",

    # 操作:int (0:禁用, 1:启用)
    134 => "存档",

    # 操作:int (0:禁用, 1:启用)
    135 => "菜单",

    # 操作:int (0:禁用, 1:启用)
    136 => "遇敌",

    # 操作:int (0:禁用, 1:启用)
    137 => "整队",

    # 窗口颜色:Tone
    138 => "更改窗口颜色",

    # 位置来源:int (0:直接指定, 1:变量指定)
    # 地图ID:int
    # X坐标:int
    # Y坐标:int
    # 人物朝向:int (0:记忆, 2:向下, 4:向左, 6:向右, 8:向上)
    # 淡入淡出:int (0:正常, 1:白色, 2:无)
    201 => "场所移动",

    # 载具ID:int
    # 位置来源:int (0:直接指定, 1:变量指定)
    # 地图ID:int
    # X坐标:int
    # Y坐标:int
    202 => "更改载具位置",

    # 事件ID:int(0:本事件, 1: EV001事件...)
    # 位置来源:int (0:直接指定, 1:变量指定)
    # 地图ID:int
    # X坐标:int
    # Y坐标:int
    # 人物朝向:int (0:记忆, 2:向下, 4:向左, 6:向右, 8:向上)
    203 => "更改事件位置",

    # 方向:int (2:向下, 4:向左, 6:向右, 8:向上)
    # 距离:int(0~100)
    # 速度:int(1:1/8速度, 2:1/4速度, 3:1/2速度, 4:正常速度, 5:2倍速度, 6:4倍速度)
    204 => "卷动地图",

    # 移动对象:int (-1:玩家, 0:本事件, 1: EV001事件...)
    # 移动路线:Array<RPG::MoveRoute>
    205 => "设置移动路线",
    206 => "载具乘/降",

    # 透明状态:int (0:透明, 1:正常)
    211 => "更改透明状态",

    # 人物ID:int(-1:玩家, 0:本事件, 1: EV001事件...)
    # 动画ID:int
    # 等待至动画结束:bool
    212 => "显示动画",

    # 人物ID:int(-1:玩家, 0:本事件, 1: EV001事件...)
    # 心情ID:int
    # 等待至动画结束:bool
    213 => "显示心情",
    214 => "暂时消除事件",

    # 队列行进:int (0:开启, 1:关闭)
    216 => "更改队列行进",
    217 => "集合队列成员",
    221 => "淡出画面",
    222 => "淡入画面",

    # 色调:Tone
    # 时间:int(单位: 1/60 sec)
    # 等待至色调变更结束:bool
    223 => "更改画面色调",

    # 颜色:Color
    # 时间:int(单位: 1/60 sec)
    # 等待至闪烁结束:bool
    224 => "闪烁画面",

    # 震动强度:int(1~9)
    # 震动速度:int(1~9)
    # 时间:int(单位: 1/60 sec)
    # 等待至震动结束:bool
    225 => "震动画面",

    # 等待时间:int(单位: 1/60 sec)
    230 => "等待",

    # 图片编号:int (0~100, 编号越大优先级越高)
    # 图片选择:string
    # 原点:int (0:左上, 1:中心)
    # 位置来源:int (0:直接指定, 1:变量指定)
    # X坐标:int(-9999~9999)
    # Y坐标:int(-9999~9999)
    # 横向百分比:int
    # 纵向百分比:int
    # 不透明度:int(0~255)
    # 合成方式:int (0:正常, 1:加法, 2:减法)
    231 => "显示图片",

    # 图片编号:int (0~100, 编号越大优先级越高)
    # nil
    # 原点:int (0:左上, 1:中心)
    # 位置来源:int (0:直接指定, 1:变量指定)
    # X坐标:int(-9999~9999)
    # Y坐标:int(-9999~9999)
    # 横向百分比:int
    # 纵向百分比:int
    # 不透明度:int(0~255)
    # 合成方式:int (0:正常, 1:加法, 2:减法)
    # 时间:int(单位: 1/60 sec)
    # 等待至移动结束:bool
    232 => "移动图片",

    # 图片编号:int (0~100, 编号越大优先级越高)
    # 旋转速度:int(-90~90)
    233 => "旋转图片",

    # 图片编号:int (0~100, 编号越大优先级越高)
    # 色调:Tone
    # 时间:int(单位: 1/60 sec)
    # 等待至色调更改结束:bool
    234 => "更改图片色调",

    # 图片编号:int (0~100, 编号越大优先级越高)
    235 => "消除图片",

    # 天气效果:string符号 (:none, :rain, :storm, :snow)
    # 强度:int(1~9)
    # 时间:int(单位: 1/60 sec)
    # 等待至天气切换结束:bool
    236 => "设置天气效果",

    # 背景音乐:RPG::BGM
    241 => "播放背景音乐",

    # 时间:int(1~60, 单位:sec)
    242 => "淡出背景音乐",
    243 => "记忆背景音乐",
    244 => "还原背景音乐",

    # 背景声音:RPG::BGS
    245 => "播放背景声音",

    # 时间:int(1~60, 单位:sec)
    246 => "淡出背景声音",

    # 播放音效:RPG::ME
    249 => "播放音效",

    # 播放声效:RPG::SE
    250 => "播放声效",
    251 => "停止声效",

    # 影像名称:string
    261 => "播放影像",

    # 操作:int (0:启用, 1:禁用)
    281 => "显示地图名称",

    # 图块组ID:int
    282 => "更换地图图块组",

    # 地面图:string
    # 墙壁图:string
    283 => "更改战斗背景图",

    # 远景图:string
    # 横向循环:bool
    # 纵向循环:bool
    # 横向自动卷动:int(-32~32, 默认为0)
    # 纵向自动卷动:int(-32~32, 默认为0)
    284 => "更改地图远景图",

    # 接受信息的变量ID:int
    # 信息种类:int (0:地形标志, 1:事件ID, 2:图块ID(层1), 3:图块ID(层2), 4:图块ID(层3), 5:区域ID)
    # 位置来源:int (0:直接指定, 1:变量指定)
    # X坐标:int
    # Y坐标:int
    285 => "获得指定位置的信息",

    # 敌群来源:int(0:直接指定, 1:变量指定, 2:随机遇敌)
    # 敌群ID:int(敌群来源为0时, 值固定为0)
    # 允许撤退:bool
    # 全灭后继续剧情:bool
    301 => "战斗处理",

    # 物品来源:int(0:物品, 1:武器, 2:护甲)
    # 物品ID:int
    # 价格:int(0:标准, 1:指定)
    #       价格为1时:
    #               价格:int(0~9999999)
    # 只允许购买:bool
    302 => "商店处理",

    # 角色ID:int
    # 名字长度:int(1~16)
    303 => "名字输入处理",

    # 角色来源:int(0:直接指定, 1:变量指定)
    # 角色来源为0时:
    #       角色ID:int (0:全体队员, 1: 001角色...)
    # 角色来源为1时:
    #       变量的ID:int
    # 操作:int (0:增加, 1:减少)
    # 数值来源:int (0:常量, 1:变量)
    # 数值:int
    # 也允许致无法战斗:bool
    311 => "增减体力值",

    # 角色来源:int(0:直接指定, 1:变量指定)
    # 角色来源为0时:
    #       角色ID:int (0:全体队员, 1: 001角色...)
    # 角色来源为1时:
    #       变量的ID:int
    # 操作:int (0:增加, 1:减少)
    # 数值来源:int (0:常量, 1:变量)
    # 数值:int
    312 => "增减魔力值",

    # 角色来源:int(0:直接指定, 1:变量指定)
    # 角色来源为0时:
    #       角色ID:int (0:全体队员, 1: 001角色...)
    # 角色来源为1时:
    #       变量的ID:int
    # 操作:int (0:附加, 1:解除)
    # 状态ID:int
    313 => "更改状态",

    # 角色来源:int(0:直接指定, 1:变量指定)
    # 角色来源为0时:
    #       角色ID:int (0:全体队员, 1: 001角色...)
    # 角色来源为1时:
    #       变量的ID:int
    314 => "完全恢复",

    # 角色来源:int(0:直接指定, 1:变量指定)
    # 角色来源为0时:
    #       角色ID:int (0:全体队员, 1: 001角色...)
    # 角色来源为1时:
    #       变量的ID:int
    # 操作:int (0:增加, 1:减少)
    # 数值来源:int (0:常量, 1:变量)
    # 数值:int
    # 显示升级信息:bool
    315 => "增减经验值",

    # 角色来源:int(0:直接指定, 1:变量指定)
    # 角色来源为0时:
    #       角色ID:int (0:全体队员, 1: 001角色...)
    # 角色来源为1时:
    #       变量的ID:int
    # 操作:int (0:增加, 1:减少)
    # 数值来源:int (0:常量, 1:变量)
    # 数值:int
    # 显示升级信息:bool
    316 => "增减等级",

    # 角色来源:int(0:直接指定, 1:变量指定)
    # 角色来源为0时:
    #       角色ID:int (0:全体队员, 1: 001角色...)
    # 角色来源为1时:
    #       变量的ID:int
    # 能力:int (0:体力上限, 1:魔力上限, 2:物理攻击, 3:物理防御, 4:魔法攻击, 5:魔法防御, 6:敏捷值, 7:幸运值)
    # 操作:int (0:增加, 1:减少)
    # 数值来源:int (0:常量, 1:变量)
    # 数值:int
    317 => "增减能力值",

    # 角色来源:int(0:直接指定, 1:变量指定)
    # 角色来源为0时:
    #       角色ID:int (0:全体队员, 1: 001角色...)
    # 角色来源为1时:
    #       变量的ID:int
    # 操作:int (0:领悟, 1:遗忘)
    # 技能ID:int
    318 => "增减技能",

    # 角色ID:int
    # 装备分类:int (0:武器, 1:盾牌, 2:头盔, 3:铠甲, 4:饰品)
    # 对应装备的ID:int
    319 => "更换装备",

    # 角色ID:int
    # 新名字:string
    320 => "更改名字",

    # 角色ID:int
    # 新职业ID:int
    321 => "更换职业",

    # 角色ID:int
    # 角色行走图:string
    # 角色行走图索引:int
    # 角色肖像图:string
    # 角色肖像图索引:int
    322 => "更换角色图像",

    # 载具ID:int
    # 载具图像:string
    # 载具图像索引:int
    323 => "更换载具图像",

    # 角色ID:int
    # 新称号:string
    324 => "更改称号",

    # 敌人ID:int(-1:全体敌人, 0:1号敌人..., 7:8号敌人)
    # 操作:int (0:增加, 1:减少)
    # 数值来源:int (0:常量, 1:变量)
    # 数值:int
    # 允许导致无法战斗:bool
    331 => "增减敌人体力值",

    # 敌人ID:int(-1:全体敌人, 0:1号敌人..., 7:8号敌人)
    # 操作:int (0:增加, 1:减少)
    # 数值来源:int (0:常量, 1:变量)
    # 数值:int
    # 允许导致无法战斗:bool
    332 => "增减敌人魔力值",

    # 敌队ID:int(-1:全体敌人, 0:1号敌人..., 7:8号敌人)
    # 操作:int (0:附加, 1:解除)
    # 状态ID:int
    333 => "更改敌人状态",

    # 敌队ID:int(-1:全体敌人, 0:1号敌人..., 7:8号敌人)
    334 => "敌人完全恢复",

    # 敌队ID:int(0:1号敌人..., 7:8号敌人 )
    335 => "敌人出现",

    # 敌队ID:int(0:1号敌人..., 7:8号敌人 )
    # 敌人ID:int
    336 => "敌人变身",

    # 敌队ID:int(-1:全体敌人, 0:1号敌人..., 7:8号敌人)
    # 动画ID:int
    337 => "显示战斗动画",

    # 行动主体:int (0:敌人, 1:角色)
    #       行动主体为0时:
    #               敌队ID:int(0:1号敌人..., 7:8号敌人)
    #       行动主体为1时:
    #               角色ID:int
    # 技能ID:int
    # 目标:int (-2:上一个目标, -1:随机, 0:1号队员,... 7:8号队员)
    339 => "强制战斗指令",
    340 => "中止战斗",
    351 => "打开菜单画面",
    352 => "打开存档画面",
    353 => "游戏结束",
    354 => "返回标题画面",

    # 脚本:string
    355 => "脚本",

    # 显示文章的字符串:string
    401 => "显示文章的字符串",

    # 选项索引:int
    # 选项名称:string
    402 => "如果选择",
    403 => "如果选择取消",
    404 => "结束_选项",

    # 显示滚动文字的字符串:string
    405 => "显示滚动文字的字符串",

    # 注释的字符串:string
    408 => "注释的字符串",
    411 => "否则",
    412 => "结束_分支",
    413 => "结束_循环",

    # 移动指令:RPG::MoveCommand
    505 => "设置移动路线_路线",
    601 => "如果队伍胜利",
    602 => "如果队伍撤退",
    603 => "如果队伍全灭",
    604 => "结束_战斗",

    # 物品来源:int(0:物品, 1:武器, 2:护甲)
    # 物品ID:int
    # 价格:int(0:标准, 1:指定)
    #       价格为1时:
    #               价格:int(0~9999999)
    605 => "商店物品",

    # 脚本的字符串:string
    655 => "脚本的字符串" }

class Color
    # 生成 Color 对象. alpha 值省略时使用 255
    # 如果没有指定参数, 默认为(0, 0, 0, 0)
    # Color.new(red, green, blue[, alpha])
    def initialize(*args)
        case args.length
        when 0 # 无参数
            set(0.0, 0.0, 0.0, 0.0)
        when 3 # 3 个参数, alpha 默认为 255
            set(*args)
        when 4 # 4 个参数, 分别为 red, green, blue, alpha
            set(*args)
        else
            raise ArgumentError, "Invalid arguments for initialize method"
        end
    end

    # set(red, green, blue[, alpha])
    # set(color)
    def set(*args)
        case args.length
        when 1 # 一个参数, 为 Color 对象
            if args[0].is_a?(Color)
                other_color = args[0]
                self.red = other_color.red
                self.green = other_color.green
                self.blue = other_color.blue
                self.alpha = other_color.alpha
            else
                raise ArgumentError, "Invalid arguments for set method"
            end
        when 3 # 三个参数, 分别为 red, green, blue (alpha 默认为 255)
            self.red = args[0]
            self.green = args[1]
            self.blue = args[2]
            self.alpha = 255.0
        when 4 # 四个参数, 分别为 red, green, blue, alpha
            self.red = args[0]
            self.green = args[1]
            self.blue = args[2]
            self.alpha = args[3]
        else
            raise ArgumentError, "Invalid arguments for set method"
        end
    end

    # 序列化对象
    def _dump(level)
        [@red, @green, @blue, @alpha].pack('D4')
    end

    # 反序列化对象
    def self._load(obj)
        new(*obj.unpack('D4'))
    end

    # 限制 red, green, blue, alpha 的值在 0 到 255 之间
    def red=(value)
        @red = [[value, 0.0].max, 255.0].min
    end

    def green=(value)
        @green = [[value, 0.0].max, 255.0].min
    end

    def blue=(value)
        @blue = [[value, 0.0].max, 255.0].min
    end

    def alpha=(value)
        @alpha = [[value, 0.0].max, 255.0].min
    end

    attr_reader :red
    attr_reader :green
    attr_reader :blue
    attr_reader :alpha
end

class Tone
    # 生成 Tone 对象. gray 值省略时使用 0
    # 若没有指定参数, 默认值为 (0, 0, 0, 0)
    # Tone.new(red, green, blue[, gray])
    def initialize(*args)
        case args.length
        when 0 # 无参数
            set(0.0, 0.0, 0.0, 0.0)
        when 3 # 3 个参数, gray 默认为 0
            set(*args)
        when 4 # 4 个参数, 分别为 red, green, blue, gray
            set(*args)
        else
            raise ArgumentError, "Invalid arguments for initialize method"
        end
    end

    # set(red, green, blue[, gray])
    # set(tone)
    def set(*args)
        case args.length
        when 1 # 一个参数, 为 Tone 对象
            if args[0].is_a?(Tone)
                self.red = args[0].red
                self.green = args[0].green
                self.blue = args[0].blue
                self.gray = args[0].gray
            else
                raise ArgumentError, "Invalid arguments for set method"
            end
        when 3 # 三个参数, 分别为 red, green, blue (gray 默认为 0)
            self.red = args[0]
            self.green = args[1]
            self.blue = args[2]
            self.gray = 0.0
        when 4 # 四个参数, 分别为 red, green, blue, gray
            self.red = args[0]
            self.green = args[1]
            self.blue = args[2]
            self.gray = args[3]
        else
            raise ArgumentError, "Invalid arguments for set method"
        end
    end

    # 序列化对象
    def _dump(level)
        [@red, @green, @blue, @gray].pack('D4')
    end

    # 反序列化对象
    def self._load(obj)
        new(*obj.unpack('D4'))
    end

    # 限制 red, green, blue的值在 -255 到 255 之间
    # 限制 gray 的值在 0 到 255 之间
    def red=(value)
        @red = [[value, -255.0].max, 255.0].min
    end

    def green=(value)
        @green = [[value, -255.0].max, 255.0].min
    end

    def blue=(value)
        @blue = [[value, -255.0].max, 255.0].min
    end

    def gray=(value)
        @gray = [[value, 0.0].max, 255.0].min
    end

    attr_reader :red
    attr_reader :green
    attr_reader :blue
    attr_reader :gray

end

# 多维数组的类. 每个元素都是带符号的两字节整数(int16_t), 也就是 -32,768~32,767 之间的整数
# Ruby Array 类在处理大量信息时效率很差，因此使用了此类。

class Table
    # 生成 Table 对象. 指定多维数组各维的长度. 生成的数组可以是 1~3 维. 生成没有元素的数组也可以
    # Table.new(xsize[, ysize[, zsize]])
    # 注意这个Table初始化时传入的参数个数就是数组的维数, 最少1维, 最多3维
    # ysize 和 zsize 省略时默认为 1
    # 该类没有参数检查, 请确保传入yszie和zsize属于[0,uint_32_max]范围
    def initialize(xsize, ysize = nil, zsize = nil)
        init_attr(xsize, ysize, zsize)
    end

    def [](x, y = 0, z = 0)
        @data[x + y * @xsize + z * @xsize * @ysize]
    end

    def []=(*args)
        v = args.pop
        x, y, z = args
        y ||= 0
        z ||= 0
        @data[x + y * @xsize + z * @xsize * @ysize] = v
    end

    def resize(xsize, ysize = nil, zsize = nil)
        old_data = @data.dup
        old_xsize, old_ysize, old_zsize = @xsize, @ysize, @zsize
        init_attr(xsize, ysize, zsize)
        (0...[old_xsize, @xsize].min).each { |x|
            (0...[old_ysize, @ysize].min).each { |y|
                (0...[old_zsize, @zsize].min).each { |z|
                    @data[x + y * @xsize + z * @xsize * @ysize] = old_data[x + y * old_xsize + z * old_xsize * old_ysize]
                }
            }
        }
    end

    def _dump(level)
        s = [@dim, @xsize, @ysize, @zsize, @xsize * @ysize * @zsize].pack('LLLLL')
        @data.each do |d|
            s << [d].pack('s')
        end
        s
    end

    def self._load(obj)
        # 从序列化字符串中解包维度信息
        dim, xsize, ysize, zsize, total_size = *obj[0, 20].unpack('LLLLL')
        # 初始化 Table 对象
        table = Table.new(*[xsize, ysize, zsize].first(dim))
        table.data = obj[20, total_size * 2].unpack("s#{total_size}")
        # 现在 @data 已经从序列化字符串中完整提取
        table
    end

    def init_attr(xsize, ysize, zsize)
        @dim = 1 + (ysize.nil? ? 0 : 1) + (zsize.nil? ? 0 : 1)
        @xsize = xsize
        @ysize = ysize.nil? ? 1 : ysize
        @zsize = zsize.nil? ? 1 : zsize
        @data = Array.new(@xsize * @ysize * @zsize, 0)
    end

    attr_accessor :data
    attr_accessor :dim
    attr_accessor :xsize
    attr_accessor :ysize
    attr_accessor :zsize
end

module RPG
    class Map
        def initialize(width, height)
            @display_name = ''
            @tileset_id = 1
            @width = width
            @height = height
            @scroll_type = 0
            @specify_battleback = false
            @battleback_floor_name = ''
            @battleback_wall_name = ''
            @autoplay_bgm = false
            @bgm = RPG::BGM.new
            @autoplay_bgs = false
            @bgs = RPG::BGS.new('', 80)
            @disable_dashing = false
            @encounter_list = []
            @encounter_step = 30
            @parallax_name = ''
            @parallax_loop_x = false
            @parallax_loop_y = false
            @parallax_sx = 0
            @parallax_sy = 0
            @parallax_show = false
            @note = ''
            @data = Table.new(width, height, 4)
            @events = {}
        end

        attr_accessor :display_name
        attr_accessor :tileset_id
        attr_accessor :width
        attr_accessor :height
        attr_accessor :scroll_type
        attr_accessor :specify_battleback
        attr_accessor :battleback1_name
        attr_accessor :battleback2_name
        attr_accessor :autoplay_bgm
        attr_accessor :bgm
        attr_accessor :autoplay_bgs
        attr_accessor :bgs
        attr_accessor :disable_dashing
        attr_accessor :encounter_list
        attr_accessor :encounter_step
        attr_accessor :parallax_name
        attr_accessor :parallax_loop_x
        attr_accessor :parallax_loop_y
        attr_accessor :parallax_sx
        attr_accessor :parallax_sy
        attr_accessor :parallax_show
        attr_accessor :note
        attr_accessor :data
        attr_accessor :events
    end

    class Map::Encounter
        def initialize
            @troop_id = 1
            @weight = 10
            @region_set = []
        end

        attr_accessor :troop_id
        attr_accessor :weight
        attr_accessor :region_set
    end

    class MapInfo
        def initialize
            @name = ''
            @parent_id = 0
            @order = 0
            @expanded = false
            @scroll_x = 0
            @scroll_y = 0
        end

        attr_accessor :name
        attr_accessor :parent_id
        attr_accessor :order
        attr_accessor :expanded
        attr_accessor :scroll_x
        attr_accessor :scroll_y
    end

    class Event
        def initialize(x, y)
            @id = 0
            @name = ''
            @x = x
            @y = y
            @pages = [RPG::Event::Page.new]
        end

        attr_accessor :id
        attr_accessor :name
        attr_accessor :x
        attr_accessor :y
        attr_accessor :pages
    end

    class Event::Page
        def initialize
            @condition = RPG::Event::Page::Condition.new
            @graphic = RPG::Event::Page::Graphic.new
            @move_type = 0
            @move_speed = 3
            @move_frequency = 3
            @move_route = RPG::MoveRoute.new
            @walk_anime = true
            @step_anime = false
            @direction_fix = false
            @through = false
            @priority_type = 0
            @trigger = 0
            @list = [RPG::EventCommand.new]
        end

        attr_accessor :condition
        attr_accessor :graphic
        attr_accessor :move_type
        attr_accessor :move_speed
        attr_accessor :move_frequency
        attr_accessor :move_route
        attr_accessor :walk_anime
        attr_accessor :step_anime
        attr_accessor :direction_fix
        attr_accessor :through
        attr_accessor :priority_type
        attr_accessor :trigger
        attr_accessor :list
    end

    class Event::Page::Condition
        def initialize
            @switch1_valid = false
            @switch2_valid = false
            @variable_valid = false
            @self_switch_valid = false
            @item_valid = false
            @actor_valid = false
            @switch1_id = 1
            @switch2_id = 1
            @variable_id = 1
            @variable_value = 0
            @self_switch_ch = 'A'
            @item_id = 1
            @actor_id = 1
        end

        attr_accessor :switch1_valid
        attr_accessor :switch2_valid
        attr_accessor :variable_valid
        attr_accessor :self_switch_valid
        attr_accessor :item_valid
        attr_accessor :actor_valid
        attr_accessor :switch1_id
        attr_accessor :switch2_id
        attr_accessor :variable_id
        attr_accessor :variable_value
        attr_accessor :self_switch_ch
        attr_accessor :item_id
        attr_accessor :actor_id
    end

    class Event::Page::Graphic
        def initialize
            @tile_id = 0
            @character_name = ''
            @character_index = 0
            @direction = 2
            @pattern = 0
        end

        attr_accessor :tile_id
        attr_accessor :character_name
        attr_accessor :character_index
        attr_accessor :direction
        attr_accessor :pattern
    end

    class EventCommand
        def initialize(code = 0, indent = 0, parameters = [])
            @code = code
            @indent = indent
            @parameters = parameters
        end

        attr_accessor :code
        attr_accessor :indent
        attr_accessor :parameters
    end

    class MoveRoute
        def initialize
            @repeat = true
            @skippable = false
            @wait = false
            @list = [RPG::MoveCommand.new]
        end

        attr_accessor :repeat
        attr_accessor :skippable
        attr_accessor :wait
        attr_accessor :list
    end

    class MoveCommand
        def initialize(code = 0, parameters = [])
            @code = code
            @parameters = parameters
        end

        attr_accessor :code
        attr_accessor :parameters
    end

    class BaseItem
        def initialize
            @id = 0
            @name = ''
            @icon_index = 0
            @description = ''
            @features = []
            @note = ''
        end

        attr_accessor :id
        attr_accessor :name
        attr_accessor :icon_index
        attr_accessor :description
        attr_accessor :features
        attr_accessor :note
    end

    class Actor < BaseItem

        def initialize
            super
            @nickname = ''
            @class_id = 1
            @initial_level = 1
            @max_level = 99
            @character_name = ''
            @character_index = 0
            @face_name = ''
            @face_index = 0
            @equips = [0, 0, 0, 0, 0]
        end

        attr_accessor :nickname
        attr_accessor :class_id
        attr_accessor :initial_level
        attr_accessor :max_level
        attr_accessor :character_name
        attr_accessor :character_index
        attr_accessor :face_name
        attr_accessor :face_index
        attr_accessor :equips
    end

    class Class < BaseItem
        def initialize
            super
            @exp_params = [30, 20, 30, 30]
            @params = Table.new(8, 100)
            (1..99).each do |i|
                @params[0, i] = 400 + i * 50
                @params[1, i] = 80 + i * 10
                (2..5).each { |j| @params[j, i] = 15 + i * 5 / 4 }
                (6..7).each { |j| @params[j, i] = 30 + i * 5 / 2 }
            end
            @learnings = []
            @features.push(RPG::BaseItem::Feature.new(23, 0, 1))
            @features.push(RPG::BaseItem::Feature.new(22, 0, 0.95))
            @features.push(RPG::BaseItem::Feature.new(22, 1, 0.05))
            @features.push(RPG::BaseItem::Feature.new(22, 2, 0.04))
            @features.push(RPG::BaseItem::Feature.new(41, 1))
            @features.push(RPG::BaseItem::Feature.new(51, 1))
            @features.push(RPG::BaseItem::Feature.new(52, 1))
        end

        def exp_for_level(level)
            lv = level.to_f
            basis = @exp_params[0].to_f
            extra = @exp_params[1].to_f
            acc_a = @exp_params[2].to_f
            acc_b = @exp_params[3].to_f
            return (basis * ((lv - 1) ** (0.9 + acc_a / 250)) * lv * (lv + 1) /
                (6 + lv ** 2 / 50 / acc_b) + (lv - 1) * extra).round.to_i
        end

        attr_accessor :exp_params
        attr_accessor :params
        attr_accessor :learnings
    end

    class UsableItem < BaseItem
        def initialize
            super
            @scope = 0
            @occasion = 0
            @speed = 0
            @success_rate = 100
            @repeats = 1
            @tp_gain = 0
            @hit_type = 0
            @animation_id = 0
            @damage = RPG::UsableItem::Damage.new
            @effects = []
        end

        def for_opponent?
            [1, 2, 3, 4, 5, 6].include?(@scope)
        end

        def for_friend?
            [7, 8, 9, 10, 11].include?(@scope)
        end

        def for_dead_friend?
            [9, 10].include?(@scope)
        end

        def for_user?
            @scope == 11
        end

        def for_one?
            [1, 3, 7, 9, 11].include?(@scope)
        end

        def for_random?
            [3, 4, 5, 6].include?(@scope)
        end

        def number_of_targets
            for_random? ? @scope - 2 : 0
        end

        def for_all?
            [2, 8, 10].include?(@scope)
        end

        def need_selection?
            [1, 7, 9].include?(@scope)
        end

        def battle_ok?
            [0, 1].include?(@occasion)
        end

        def menu_ok?
            [0, 2].include?(@occasion)
        end

        def certain?
            @hit_type == 0
        end

        def physical?
            @hit_type == 1
        end

        def magical?
            @hit_type == 2
        end

        attr_accessor :scope
        attr_accessor :occasion
        attr_accessor :speed
        attr_accessor :animation_id
        attr_accessor :success_rate
        attr_accessor :repeats
        attr_accessor :tp_gain
        attr_accessor :hit_type
        attr_accessor :damage
        attr_accessor :effects
    end

    class Skill < UsableItem
        def initialize
            super
            @scope = 1
            @stype_id = 1
            @mp_cost = 0
            @tp_cost = 0
            @message1 = ''
            @message2 = ''
            @required_wtype_id1 = 0
            @required_wtype_id2 = 0
        end

        attr_accessor :stype_id
        attr_accessor :mp_cost
        attr_accessor :tp_cost
        attr_accessor :message1
        attr_accessor :message2
        attr_accessor :required_wtype_id1
        attr_accessor :required_wtype_id2
    end

    class Item < UsableItem
        def initialize
            super
            @scope = 7
            @itype_id = 1
            @price = 0
            @consumable = true
        end

        def key_item?
            @itype_id == 2
        end

        attr_accessor :itype_id
        attr_accessor :price
        attr_accessor :consumable
    end

    class EquipItem < BaseItem
        def initialize
            super
            @price = 0
            @etype_id = 0
            @params = [0] * 8
        end

        attr_accessor :price
        attr_accessor :etype_id
        attr_accessor :params
    end

    class Weapon < EquipItem
        def initialize
            super
            @wtype_id = 0
            @animation_id = 0
            @features.push(RPG::BaseItem::Feature.new(31, 1, 0))
            @features.push(RPG::BaseItem::Feature.new(22, 0, 0))
        end

        def performance
            params[2] + params[4] + params.inject(0) { |r, v| r += v }
        end

        attr_accessor :wtype_id
        attr_accessor :animation_id
    end

    class Armor < EquipItem
        def initialize
            super
            @atype_id = 0
            @etype_id = 1
            @features.push(RPG::BaseItem::Feature.new(22, 1, 0))
        end

        def performance
            params[3] + params[5] + params.inject(0) { |r, v| r += v }
        end

        attr_accessor :atype_id
    end

    class Enemy < BaseItem
        def initialize
            super
            @battler_name = ''
            @battler_hue = 0
            @params = [100, 0, 10, 10, 10, 10, 10, 10]
            @exp = 0
            @gold = 0
            @drop_items = Array.new(3) { RPG::Enemy::DropItem.new }
            @actions = [RPG::Enemy::Action.new]
            @features.push(RPG::BaseItem::Feature.new(22, 0, 0.95))
            @features.push(RPG::BaseItem::Feature.new(22, 1, 0.05))
            @features.push(RPG::BaseItem::Feature.new(31, 1, 0))
        end

        attr_accessor :battler_name
        attr_accessor :battler_hue
        attr_accessor :params
        attr_accessor :exp
        attr_accessor :gold
        attr_accessor :drop_items
        attr_accessor :actions
    end

    class State < BaseItem
        def initialize
            super
            @restriction = 0
            @priority = 50
            @remove_at_battle_end = false
            @remove_by_restriction = false
            @auto_removal_timing = 0
            @min_turns = 1
            @max_turns = 1
            @remove_by_damage = false
            @chance_by_damage = 100
            @remove_by_walking = false
            @steps_to_remove = 100
            @message1 = ''
            @message2 = ''
            @message3 = ''
            @message4 = ''
        end

        attr_accessor :restriction
        attr_accessor :priority
        attr_accessor :remove_at_battle_end
        attr_accessor :remove_by_restriction
        attr_accessor :auto_removal_timing
        attr_accessor :min_turns
        attr_accessor :max_turns
        attr_accessor :remove_by_damage
        attr_accessor :chance_by_damage
        attr_accessor :remove_by_walking
        attr_accessor :steps_to_remove
        attr_accessor :message1
        attr_accessor :message2
        attr_accessor :message3
        attr_accessor :message4
    end

    class BaseItem::Feature
        def initialize(code = 0, data_id = 0, value = 0)
            @code = code
            @data_id = data_id
            @value = value
        end

        attr_accessor :code
        attr_accessor :data_id
        attr_accessor :value
    end

    class UsableItem::Damage
        def initialize
            @type = 0
            @element_id = 0
            @formula = '0'
            @variance = 20
            @critical = false
        end

        def none?
            @type == 0
        end

        def to_hp?
            [1, 3, 5].include?(@type)
        end

        def to_mp?
            [2, 4, 6].include?(@type)
        end

        def recover?
            [3, 4].include?(@type)
        end

        def drain?
            [5, 6].include?(@type)
        end

        def sign
            recover? ? -1 : 1
        end

        def eval(a, b, v)
            [Kernel.eval(@formula), 0].max * sign rescue 0
        end

        attr_accessor :type
        attr_accessor :element_id
        attr_accessor :formula
        attr_accessor :variance
        attr_accessor :critical
    end

    class UsableItem::Effect
        def initialize(code = 0, data_id = 0, value1 = 0, value2 = 0)
            @code = code
            @data_id = data_id
            @value1 = value1
            @value2 = value2
        end

        attr_accessor :code
        attr_accessor :data_id
        attr_accessor :value1
        attr_accessor :value2
    end

    class Class::Learning
        def initialize
            @level = 1
            @skill_id = 1
            @note = ''
        end

        attr_accessor :level
        attr_accessor :skill_id
        attr_accessor :note
    end

    class Enemy::DropItem
        def initialize
            @kind = 0
            @data_id = 1
            @denominator = 1
        end

        attr_accessor :kind
        attr_accessor :data_id
        attr_accessor :denominator
    end

    class Enemy::Action
        def initialize
            @skill_id = 1
            @condition_type = 0
            @condition_param1 = 0
            @condition_param2 = 0
            @rating = 5
        end

        attr_accessor :skill_id
        attr_accessor :condition_type
        attr_accessor :condition_param1
        attr_accessor :condition_param2
        attr_accessor :rating
    end

    class Troop
        def initialize
            @id = 0
            @name = ''
            @members = []
            @pages = [RPG::Troop::Page.new]
        end

        attr_accessor :id
        attr_accessor :name
        attr_accessor :members
        attr_accessor :pages
    end

    class Troop::Member
        def initialize
            @enemy_id = 1
            @x = 0
            @y = 0
            @hidden = false
        end

        attr_accessor :enemy_id
        attr_accessor :x
        attr_accessor :y
        attr_accessor :hidden
    end

    class Troop::Page
        def initialize
            @condition = RPG::Troop::Page::Condition.new
            @span = 0
            @list = [RPG::EventCommand.new]
        end

        attr_accessor :condition
        attr_accessor :span
        attr_accessor :list
    end

    class Troop::Page::Condition
        def initialize
            @turn_ending = false
            @turn_valid = false
            @enemy_valid = false
            @actor_valid = false
            @switch_valid = false
            @turn_a = 0
            @turn_b = 0
            @enemy_index = 0
            @enemy_hp = 50
            @actor_id = 1
            @actor_hp = 50
            @switch_id = 1
        end

        attr_accessor :turn_ending
        attr_accessor :turn_valid
        attr_accessor :enemy_valid
        attr_accessor :actor_valid
        attr_accessor :switch_valid
        attr_accessor :turn_a
        attr_accessor :turn_b
        attr_accessor :enemy_index
        attr_accessor :enemy_hp
        attr_accessor :actor_id
        attr_accessor :actor_hp
        attr_accessor :switch_id
    end

    class Animation
        def initialize
            @id = 0
            @name = ''
            @animation1_name = ''
            @animation1_hue = 0
            @animation2_name = ''
            @animation2_hue = 0
            @position = 1
            @frame_max = 1
            @frames = [RPG::Animation::Frame.new]
            @timings = []
        end

        def to_screen?
            @position == 3
        end

        attr_accessor :id
        attr_accessor :name
        attr_accessor :animation1_name
        attr_accessor :animation1_hue
        attr_accessor :animation2_name
        attr_accessor :animation2_hue
        attr_accessor :position
        attr_accessor :frame_max
        attr_accessor :frames
        attr_accessor :timings
    end

    class Animation::Frame
        def initialize
            @cell_max = 0
            @cell_data = Table.new(0, 0)
        end

        attr_accessor :cell_max
        attr_accessor :cell_data
    end

    class Animation::Timing
        def initialize
            @frame = 0
            @se = RPG::SE.new('', 80)
            @flash_scope = 0
            @flash_color = Color.new(255, 255, 255, 255)
            @flash_duration = 5
        end

        attr_accessor :frame
        attr_accessor :se
        attr_accessor :flash_scope
        attr_accessor :flash_color
        attr_accessor :flash_duration
    end

    class Tileset
        def initialize
            @id = 0
            @mode = 1
            @name = ''
            @tileset_names = Array.new(9).collect { '' }
            @flags = Table.new(8192)
            @flags[0] = 0x0010
            (2048..2815).each { |i| @flags[i] = 0x000F }
            (4352..8191).each { |i| @flags[i] = 0x000F }
            @note = ''
        end

        attr_accessor :id
        attr_accessor :mode
        attr_accessor :name
        attr_accessor :tileset_names
        attr_accessor :flags
        attr_accessor :note
    end

    class CommonEvent
        def initialize
            @id = 0
            @name = ''
            @trigger = 0
            @switch_id = 1
            @list = [RPG::EventCommand.new]
        end

        def autorun?
            @trigger == 1
        end

        def parallel?
            @trigger == 2
        end

        attr_accessor :id
        attr_accessor :name
        attr_accessor :trigger
        attr_accessor :switch_id
        attr_accessor :list
    end

    class System
        def initialize
            @game_title = ''
            @version_id = 0
            @japanese = true
            @party_members = [1]
            @currency_unit = ''
            @elements = [nil, '']
            @skill_types = [nil, '']
            @weapon_types = [nil, '']
            @armor_types = [nil, '']
            @switches = [nil, '']
            @variables = [nil, '']
            @boat = RPG::System::Vehicle.new
            @ship = RPG::System::Vehicle.new
            @airship = RPG::System::Vehicle.new
            @title1_name = ''
            @title2_name = ''
            @opt_draw_title = true
            @opt_use_midi = false
            @opt_transparent = false
            @opt_followers = true
            @opt_slip_death = false
            @opt_floor_death = false
            @opt_display_tp = true
            @opt_extra_exp = false
            @window_tone = Tone.new(0, 0, 0)
            @title_bgm = RPG::BGM.new
            @battle_bgm = RPG::BGM.new
            @battle_end_me = RPG::ME.new
            @gameover_me = RPG::ME.new
            @sounds = Array.new(24) { RPG::SE.new }
            @test_battlers = []
            @test_troop_id = 1
            @start_map_id = 1
            @start_x = 0
            @start_y = 0
            @terms = RPG::System::Terms.new
            @battleback1_name = ''
            @battleback2_name = ''
            @battler_name = ''
            @battler_hue = 0
            @edit_map_id = 1
        end

        attr_accessor :game_title
        attr_accessor :version_id
        attr_accessor :japanese
        attr_accessor :party_members
        attr_accessor :currency_unit
        attr_accessor :skill_types
        attr_accessor :weapon_types
        attr_accessor :armor_types
        attr_accessor :elements
        attr_accessor :switches
        attr_accessor :variables
        attr_accessor :boat
        attr_accessor :ship
        attr_accessor :airship
        attr_accessor :title1_name
        attr_accessor :title2_name
        attr_accessor :opt_draw_title
        attr_accessor :opt_use_midi
        attr_accessor :opt_transparent
        attr_accessor :opt_followers
        attr_accessor :opt_slip_death
        attr_accessor :opt_floor_death
        attr_accessor :opt_display_tp
        attr_accessor :opt_extra_exp
        attr_accessor :window_tone
        attr_accessor :title_bgm
        attr_accessor :battle_bgm
        attr_accessor :battle_end_me
        attr_accessor :gameover_me
        attr_accessor :sounds
        attr_accessor :test_battlers
        attr_accessor :test_troop_id
        attr_accessor :start_map_id
        attr_accessor :start_x
        attr_accessor :start_y
        attr_accessor :terms
        attr_accessor :battleback1_name
        attr_accessor :battleback2_name
        attr_accessor :battler_name
        attr_accessor :battler_hue
        attr_accessor :edit_map_id
    end

    class System::Vehicle
        def initialize
            @character_name = ''
            @character_index = 0
            @bgm = RPG::BGM.new
            @start_map_id = 0
            @start_x = 0
            @start_y = 0
        end

        attr_accessor :character_name
        attr_accessor :character_index
        attr_accessor :bgm
        attr_accessor :start_map_id
        attr_accessor :start_x
        attr_accessor :start_y
    end

    class System::Terms
        def initialize
            @basic = Array.new(8) { '' }
            @params = Array.new(8) { '' }
            @etypes = Array.new(5) { '' }
            @commands = Array.new(23) { '' }
        end

        attr_accessor :basic
        attr_accessor :params
        attr_accessor :etypes
        attr_accessor :commands
    end

    class System::TestBattler
        def initialize
            @actor_id = 1
            @level = 1
            @equips = [0, 0, 0, 0, 0]
        end

        attr_accessor :actor_id
        attr_accessor :level
        attr_accessor :equips
    end

    class AudioFile
        def initialize(name = '', volume = 100, pitch = 100)
            @name = name
            @volume = volume
            @pitch = pitch
        end

        attr_accessor :name
        attr_accessor :volume
        attr_accessor :pitch
    end

    class BGM < AudioFile
        @@last = RPG::BGM.new

        def play(pos = 0)
            if @name.empty?
                Audio.bgm_stop
                @@last = RPG::BGM.new
            else
                Audio.bgm_play('Audio/BGM/' + @name, @volume, @pitch, pos)
                @@last = self.clone
            end
        end

        def replay
            play(@pos)
        end

        def self.stop
            Audio.bgm_stop
            @@last = RPG::BGM.new
        end

        def self.fade(time)
            Audio.bgm_fade(time)
            @@last = RPG::BGM.new
        end

        def self.last
            @@last.pos = Audio.bgm_pos
            @@last
        end

        attr_accessor :pos
    end

    class BGS < AudioFile
        @@last = RPG::BGS.new

        def play(pos = 0)
            if @name.empty?
                Audio.bgs_stop
                @@last = RPG::BGS.new
            else
                Audio.bgs_play('Audio/BGS/' + @name, @volume, @pitch, pos)
                @@last = self.clone
            end
        end

        def replay
            play(@pos)
        end

        def self.stop
            Audio.bgs_stop
            @@last = RPG::BGS.new
        end

        def self.fade(time)
            Audio.bgs_fade(time)
            @@last = RPG::BGS.new
        end

        def self.last
            @@last.pos = Audio.bgs_pos
            @@last
        end

        attr_accessor :pos
    end

    class ME < AudioFile
        def play
            if @name.empty?
                Audio.me_stop
            else
                Audio.me_play('Audio/ME/' + @name, @volume, @pitch)
            end
        end

        def self.stop
            Audio.me_stop
        end

        def self.fade(time)
            Audio.me_fade(time)
        end
    end

    class SE < AudioFile
        def play
            unless @name.empty?
                Audio.se_play('Audio/SE/' + @name, @volume, @pitch)
            end
        end

        def self.stop
            Audio.se_stop
        end
    end
end