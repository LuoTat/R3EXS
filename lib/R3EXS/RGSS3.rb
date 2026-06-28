# frozen_string_literal: true

# RPG Maker VX Ace Color 类
class Color
  attr_accessor :red,
                :green,
                :blue,
                :alpha

  # 序列化 Color 对象
  #
  # @return [String]
  def _dump(_level)
    [@red, @green, @blue, @alpha].pack('D4')
  end

  # 反序列化 Color 对象
  #
  # @param obj [String] 序列化后的字符串
  #
  # @return [Color]
  def self._load(obj)
    r, g, b, a = obj.unpack('D4')
    instance = Color.allocate
    instance.red = r
    instance.green = g
    instance.blue = b
    instance.alpha = a
    instance
  end
end

# RPG Maker VX Ace Tone 类
class Tone
  attr_accessor :red,
                :green,
                :blue,
                :gray

  # 初始化 Tone 对象
  #
  # @param red [Integer] 红色通道的值 (0-255)
  # @param green [Integer] 绿色通道的值 (0-255)
  # @param blue [Integer] 蓝色通道的值 (0-255)
  # @param gray [Integer] 灰度通道的值 (0-255)
  #
  # @return [Color]
  def initialize(red, green, blue, gray)
    @red = red
    @green = green
    @blue = blue
    @gray = gray
  end

  # 序列化 Tone 对象
  #
  # @return [String]
  def _dump(_level)
    [@red, @green, @blue, @gray].pack('D4')
  end

  # 反序列化 Tone 对象
  #
  # @param obj [String] 序列化后的字符串
  #
  # @return [Tone]
  def self._load(obj)
    r, g, b, y = obj.unpack('D4')
    instance = Tone.allocate
    instance.red = r
    instance.green = g
    instance.blue = b
    instance.gray = y
    instance
  end
end

# RPG Maker VX Ace Table 类
#
# Table 是一个多维数组，每个元素都是带符号的两字节整数(int16_t), 也就是 -32,768~32,767 之间的整数
#
# Ruby Array 类在处理大量信息时效率很差，因此使用了此类。
class Table
  attr_accessor :dim,
                :xsize,
                :ysize,
                :zsize,
                :data

  # 序列化 Table 对象
  #
  # @return [String]
  def _dump(_level)
    total = @xsize * @ysize * @zsize
    [@dim, @xsize, @ysize, @zsize, total].pack('L5') + @data.pack('s*')
  end

  # 反序列化 Table 对象
  #
  # @param obj [String] 序列化后的字符串
  #
  # @return [Table]
  def self._load(obj)
    dim, xsize, ysize, zsize, total_size, *data = obj.unpack('L5s*')
    instance = allocate
    instance.dim = dim
    instance.xsize = xsize
    instance.ysize = ysize
    instance.zsize = zsize
    instance.data = data.first(total_size)
    instance
  end
end

# RPG Maker VX Ace 的RPG 模块
module RPG
  # 地图数据类
  class Map
    attr_accessor :display_name,
                  :tileset_id,
                  :width,
                  :height,
                  :scroll_type,
                  :specify_battleback,
                  :battleback1_name,
                  :battleback2_name,
                  :autoplay_bgm,
                  :bgm,
                  :autoplay_bgs,
                  :bgs,
                  :disable_dashing,
                  :encounter_list,
                  :encounter_step,
                  :parallax_name,
                  :parallax_loop_x,
                  :parallax_loop_y,
                  :parallax_sx,
                  :parallax_sy,
                  :parallax_show,
                  :note,
                  :data,
                  :events

    # 存储遇敌设置的数据类
    class Encounter
      attr_accessor :troop_id,
                    :weight,
                    :region_set
    end
  end

  # 地图信息的数据类
  class MapInfo
    attr_accessor :name,
                  :parent_id,
                  :order,
                  :expanded,
                  :scroll_x,
                  :scroll_y
  end

  # 地图事件的数据类
  class Event
    attr_accessor :id,
                  :name,
                  :x,
                  :y,
                  :pages

    # 地图事件块事件页资料
    class Page
      attr_accessor :condition,
                    :graphic,
                    :move_type,
                    :move_speed,
                    :move_frequency,
                    :move_route,
                    :walk_anime,
                    :step_anime,
                    :direction_fix,
                    :through,
                    :priority_type,
                    :trigger,
                    :list

      # 地图事件块事件页条件的数据类
      class Condition
        attr_accessor :switch1_valid,
                      :switch2_valid,
                      :variable_valid,
                      :self_switch_valid,
                      :item_valid,
                      :actor_valid,
                      :switch1_id,
                      :switch2_id,
                      :variable_id,
                      :variable_value,
                      :self_switch_ch,
                      :item_id,
                      :actor_id
      end

      # 地图事件块事件页「图片」的数据类
      class Graphic
        attr_accessor :tile_id,
                      :character_name,
                      :character_index,
                      :direction,
                      :pattern
      end
    end
  end

  # 事件指令的数据类
  class EventCommand
    attr_accessor :code,
                  :indent,
                  :parameters
  end

  # 移动路线的数据类
  class MoveRoute
    attr_accessor :repeat,
                  :skippable,
                  :wait,
                  :list
  end

  # 移动路线指令的数据类
  class MoveCommand
    attr_accessor :code,
                  :parameters
  end

  # 角色、职业、技能、物品、武器、护甲、敌人和状态的超类
  class BaseItem
    attr_accessor :id,
                  :name,
                  :icon_index,
                  :description,
                  :features,
                  :note

    # 特性的数据类
    class Feature
      attr_accessor :code,
                    :data_id,
                    :value
    end
  end

  # 角色的数据类
  class Actor < BaseItem
    attr_accessor :nickname,
                  :class_id,
                  :initial_level,
                  :max_level,
                  :character_name,
                  :character_index,
                  :face_name,
                  :face_index,
                  :equips
  end

  # 职业的数据类
  class Class < BaseItem
    attr_accessor :exp_params,
                  :params,
                  :learnings

    # 职业[技能]的数据类
    class Learning
      attr_accessor :level,
                    :skill_id,
                    :note
    end
  end

  # 技能和物品的超类
  class UsableItem < BaseItem
    attr_accessor :scope,
                  :occasion,
                  :speed,
                  :animation_id,
                  :success_rate,
                  :repeats,
                  :tp_gain,
                  :hit_type,
                  :damage,
                  :effects

    # 伤害的数据类
    class Damage
      attr_accessor :type,
                    :element_id,
                    :formula,
                    :variance,
                    :critical
    end

    # 使用效果的数据类
    class Effect
      attr_accessor :code,
                    :data_id,
                    :value1,
                    :value2
    end
  end

  # 技能的数据类
  class Skill < UsableItem
    attr_accessor :stype_id,
                  :mp_cost,
                  :tp_cost,
                  :message1,
                  :message2,
                  :required_wtype_id1,
                  :required_wtype_id2
  end

  # 物品的数据类
  class Item < UsableItem
    attr_accessor :itype_id,
                  :price,
                  :consumable
  end

  # 武器与护甲的超类
  class EquipItem < BaseItem
    attr_accessor :price,
                  :etype_id,
                  :params
  end

  # 武器的数据类
  class Weapon < EquipItem
    attr_accessor :wtype_id,
                  :animation_id
  end

  # 护甲的数据类
  class Armor < EquipItem
    attr_accessor :atype_id
  end

  # 敌人的数据类
  class Enemy < BaseItem
    attr_accessor :battler_name,
                  :battler_hue,
                  :params,
                  :exp,
                  :gold,
                  :drop_items,
                  :actions

    # 敌人掉落物品的数据类
    class DropItem
      attr_accessor :kind,
                    :data_id,
                    :denominator
    end

    # 敌人[行为模式]的数据类
    class Action
      attr_accessor :skill_id,
                    :condition_type,
                    :condition_param1,
                    :condition_param2,
                    :rating
    end
  end

  # 状态的数据类
  class State < BaseItem
    attr_accessor :restriction,
                  :priority,
                  :remove_at_battle_end,
                  :remove_by_restriction,
                  :auto_removal_timing,
                  :min_turns,
                  :max_turns,
                  :remove_by_damage,
                  :chance_by_damage,
                  :remove_by_walking,
                  :steps_to_remove,
                  :message1,
                  :message2,
                  :message3,
                  :message4
  end

  # 敌人队伍的数据类
  class Troop
    attr_accessor :id,
                  :name,
                  :members,
                  :pages

    # 敌方队员的数据类
    class Member
      attr_accessor :enemy_id,
                    :x,
                    :y,
                    :hidden
    end

    # 战斗事件（页）的数据类
    class Page
      attr_accessor :condition,
                    :span,
                    :list

      # 战斗事件的「条件」数据类
      class Condition
        attr_accessor :turn_ending,
                      :turn_valid,
                      :enemy_valid,
                      :actor_valid,
                      :switch_valid,
                      :turn_a,
                      :turn_b,
                      :enemy_index,
                      :enemy_hp,
                      :actor_id,
                      :actor_hp,
                      :switch_id
      end
    end
  end

  # 动画的数据类
  class Animation
    attr_accessor :id,
                  :name,
                  :animation1_name,
                  :animation1_hue,
                  :animation2_name,
                  :animation2_hue,
                  :position,
                  :frame_max,
                  :frames,
                  :timings

    # 动画帧的数据类
    class Frame
      attr_accessor :cell_max,
                    :cell_data
    end

    # 动画的[声效与闪烁效果]的数据类
    class Timing
      attr_accessor :frame,
                    :se,
                    :flash_scope,
                    :flash_color,
                    :flash_duration
    end
  end

  # 图块的数据类
  class Tileset
    attr_accessor :id,
                  :mode,
                  :name,
                  :tileset_names,
                  :flags,
                  :note
  end

  # 公共事件的数据类
  class CommonEvent
    attr_accessor :id,
                  :name,
                  :trigger,
                  :switch_id,
                  :list
  end

  # 系统的数据类
  class System
    attr_accessor :game_title,
                  :version_id,
                  :japanese,
                  :party_members,
                  :currency_unit,
                  :skill_types,
                  :weapon_types,
                  :armor_types,
                  :elements,
                  :switches,
                  :variables,
                  :boat,
                  :ship,
                  :airship,
                  :title1_name,
                  :title2_name,
                  :opt_draw_title,
                  :opt_use_midi,
                  :opt_transparent,
                  :opt_followers,
                  :opt_slip_death,
                  :opt_floor_death,
                  :opt_display_tp,
                  :opt_extra_exp,
                  :window_tone,
                  :title_bgm,
                  :battle_bgm,
                  :battle_end_me,
                  :gameover_me,
                  :sounds,
                  :test_battlers,
                  :test_troop_id,
                  :start_map_id,
                  :start_x,
                  :start_y,
                  :terms,
                  :battleback1_name,
                  :battleback2_name,
                  :battler_name,
                  :battler_hue,
                  :edit_map_id

    # 交通工具的数据类
    class Vehicle
      attr_accessor :character_name,
                    :character_index,
                    :bgm,
                    :start_map_id,
                    :start_x,
                    :start_y
    end

    # 用语的资料类
    class Terms
      attr_accessor :basic,
                    :params,
                    :etypes,
                    :commands
    end

    # 战斗测试中使用的角色数据类
    class TestBattler
      attr_accessor :actor_id,
                    :level,
                    :equips
    end
  end

  # BGM、BGS、ME、SE的超类
  class AudioFile
    attr_accessor :name,
                  :volume,
                  :pitch
  end

  # BGM 的数据类
  class BGM < AudioFile
    attr_accessor :pos
  end

  # BGS 的数据类
  class BGS < AudioFile
    attr_accessor :pos
  end

  # ME 的数据类
  class ME < AudioFile
  end

  # SE 的数据类
  class SE < AudioFile
  end
end
