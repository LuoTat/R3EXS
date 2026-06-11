# frozen_string_literal: true

module R3EXS

  # 基础物品类
  class BaseItem

    # 在原始数组中的索引
    #
    # @return [Integer]
    attr_reader :index

    # 物品名称
    #
    # @return [String]
    attr_accessor :name

    # 物品描述
    #
    # @return [String]
    attr_accessor :description

    # 物品注释
    #
    # @return [String]
    attr_accessor :note

    # 用 RPG::BaseItem 初始化
    #
    # @param baseitem [RPG::BaseItem] 待处理的 RPG::BaseItem 对象
    # @param index [Integer] 在原始数组中的索引
    # @param with_note [Boolean] 是否处理 note 字段
    #
    # @return [R3EXS::BaseItem]
    def initialize(baseitem, index, with_note)
      @index = index
      @name = baseitem.name
      @description = baseitem.description
      @note = baseitem.note
      self.remove_instance_variable(:@note) unless with_note
    end

    # 注入到 RPG::BaseItem 对象
    #
    # @param baseitem [RPG::BaseItem] 待注入的 RPG::BaseItem 对象
    #
    # @return [void]
    def inject_to(baseitem)
      baseitem.name = @name
      baseitem.description = @description if self.instance_variable_defined?(:@description)
      baseitem.note = @note if self.instance_variable_defined?(:@note)
    end

    # 提取所有的字符串
    #
    # @return [Array<String>]
    def ex_strings
      strings = []
      strings << @name
      strings << @description if self.instance_variable_defined?(:@description)
      strings << @note if self.instance_variable_defined?(:@note)
      strings
    end

    # 将所有的字符串替换为指定的字符串
    #
    # @param hash [Hash<String, String>] 字符串翻译表
    #
    # @return [void]
    def in_strings(hash)
      @name = hash[@name] || @name
      @description = hash[@description] || @description if self.instance_variable_defined?(:@description)
      @note = hash[@note] || @note if self.instance_variable_defined?(:@note)
    end

    # 判断是否为空
    #
    # @return [Boolean]
    def empty?
      @name.to_s.empty? && @description.to_s.empty? && @note.to_s.empty?
    end
  end

  # 角色类
  class Actor < BaseItem

    # 昵称
    #
    # @return [String]
    attr_accessor :nickname

    # 用 RPG::Actor 初始化
    #
    # @param actor [RPG::Actor] 待处理的 RPG::Actor 对象
    # @param index [Integer] 在原始数组中的索引
    # @param with_note [Boolean] 是否处理 note 字段
    #
    # @return [R3EXS::Actor]
    def initialize(actor, index, with_note)
      super(actor, index, with_note)
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
    # @param hash [Hash<String, String>] 字符串翻译表
    #
    # @return [void]
    def in_strings(hash)
      super(hash)
      @nickname = hash[@nickname] || @nickname
    end

    # 判断是否为空
    #
    # @return [Boolean]
    def empty?
      super && @nickname.to_s.empty?
    end
  end

  # 动画类
  class Animation

    # 在原始数组中的索引
    #
    # @return [Integer]
    attr_reader :index

    # 动画名称
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
    # @param hash [Hash<String, String>] 字符串翻译表
    #
    # @return [void]
    def in_strings(hash)
      @name = hash[@name] || @name
    end

    # 判断是否为空
    #
    # @return [Boolean]
    def empty?
      @name.to_s.empty?
    end
  end

  # 可装备物品类
  class EquipItem < BaseItem

    # 用 RPG::EquipItem 初始化
    #
    # @param equipitem [RPG::EquipItem] 待处理的 RPG::EquipItem 对象
    # @param index [Integer] 在原始数组中的索引
    # @param with_note [Boolean] 是否处理 note 字段
    #
    # @return [R3EXS::EquipItem]
    def initialize(equipitem, index, with_note)
      super(equipitem, index, with_note)
    end

    # 注入到 RPG::EquipItem 对象
    #
    # @param equipitem [RPG::EquipItem] 待注入的 RPG::EquipItem 对象
    #
    # @return [void]
    def inject_to(equipitem)
      super
    end

    # 提取所有的字符串
    #
    # @return [Array<String>]
    def ex_strings
      super
    end

    # 将所有的字符串替换为指定的字符串
    #
    # @param hash [Hash<String, String>] 字符串翻译表
    #
    # @return [void]
    def in_strings(hash)
      super(hash)
    end

    # 判断是否为空
    #
    # @return [Boolean]
    def empty?
      super
    end
  end

  # 护甲类
  class Armor < EquipItem

    # 用 RPG::Armor 初始化
    #
    # @param armor [RPG::Armor] 待处理的 RPG::Armor 对象
    # @param index [Integer] 在原始数组中的索引
    # @param with_note [Boolean] 是否处理 note 字段
    #
    # @return [R3EXS::Armor]
    def initialize(armor, index, with_note)
      super(armor, index, with_note)
    end

    # 注入到 RPG::Armor 对象
    #
    # @param armor [RPG::Armor] 待注入的 RPG::Armor 对象
    #
    # @return [void]
    def inject_to(armor)
      super
    end

    # 提取所有的字符串
    #
    # @return [Array<String>]
    def ex_strings
      super
    end

    # 将所有的字符串替换为指定的字符串
    #
    # @param hash [Hash<String, String>] 字符串翻译表
    #
    # @return [void]
    def in_strings(hash)
      super(hash)
    end

    # 判断是否为空
    #
    # @return [Boolean]
    def empty?
      super
    end
  end

  # 职业类
  class Class < BaseItem

    # 职业的学习技能列表
    #
    # @return [Array<R3EXS::Class::Learning>]
    attr_accessor :learnings

    # 学习技能类
    class Learning

      # 在原始数组中的索引
      #
      # @return [Integer]
      attr_reader :index

      # 学习技能注释
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
      # @param hash [Hash<String, String>] 字符串翻译表
      #
      # @return [void]
      def in_strings(hash)
        @note = hash[@note] || @note
      end

      # 判断是否为空
      #
      # @return [Boolean]
      def empty?
        @note.to_s.empty?
      end
    end

    # 用 RPG::Class 初始化
    #
    # @param klass [RPG::Class] 待处理的 RPG::Class 对象
    # @param index [Integer] 在原始数组中的索引
    # @param with_note [Boolean] 是否处理 note 字段
    #
    # @return [R3EXS::Class]
    def initialize(klass, index, with_note)
      super(klass, index, with_note)
      @learnings = []
      klass.learnings.each_with_index do |learning, learning_index|
        next if learning == nil
        learning_r3exs = R3EXS::Class::Learning.new(learning, learning_index)
        @learnings << learning_r3exs unless learning_r3exs.empty?
      end
      self.remove_instance_variable(:@description)
      self.remove_instance_variable(:@learnings) unless with_note
    end

    # 注入到 RPG::Class 对象
    #
    # @param klass [RPG::Class] 待注入的 RPG::Class 对象
    #
    # @return [void]
    def inject_to(klass)
      super(klass)
      if self.instance_variable_defined?(:@learnings)
        @learnings.each do |learning|
          learning.inject_to(klass.learnings[learning.index])
        end
      end
    end

    # 提取所有的字符串
    #
    # @return [Array<String>]
    def ex_strings
      strings = super
      if self.instance_variable_defined?(:@learnings)
        @learnings.each do |learning|
          strings.concat(learning.ex_strings)
        end
      end
      strings
    end

    # 将所有的字符串替换为指定的字符串
    #
    # @param hash [Hash<String, String>] 字符串翻译表
    #
    # @return [void]
    def in_strings(hash)
      super(hash)
      if self.instance_variable_defined?(:@learnings)
        @learnings.each do |learning|
          learning.in_strings(hash)
        end
      end
    end

    # 判断是否为空
    #
    # @return [Boolean]
    def empty?
      super && @learnings.to_a.empty?
    end
  end

  # 移动指令类
  class MoveCommand

    # 在原始数组中的索引
    #
    # @return [Integer]
    attr_accessor :index

    # 移动指令代码
    #
    # @return [Integer]
    attr_accessor :code

    # 移动指令用途
    #
    # @return [String]
    attr_accessor :usage

    # 移动指令参数
    #
    # @return [String]
    attr_accessor :parameter

    # 用 RPG::MoveCommand 初始化
    #
    # @param movecommand [RPG::MoveCommand] 待处理的 RPG::MoveCommand 对象
    # @param index [Integer] 在原始数组中的索引
    #
    # @return [R3EXS::MoveCommand]
    def initialize(movecommand, index)
      if movecommand.code == 45
        @index = index
        @code = 45
        @usage = 'MoveCommandScript'
        @parameter = movecommand.parameters[0]
      else
        @index = -1
      end
    end

    # 注入到 RPG::MoveCommand 对象
    #
    # @param movecommand [RPG::MoveCommand] 待注入的 RPG::MoveCommand 对象
    #
    # @return [void]
    def inject_to(movecommand)
      movecommand.parameters[0] = @parameter
    end

    # 提取所有的字符串
    #
    # @return [Array<String>]
    def ex_strings
      [@parameter]
    end

    # 将所有的字符串替换为指定的字符串
    #
    # @param hash [Hash<String, String>] 字符串翻译表
    #
    # @return [void]
    def in_strings(hash)
      @parameter = hash[@parameter] || @parameter
    end

    # 判断是否为空
    #
    # @return [Boolean]
    def empty?
      @index == -1
    end
  end

  # 移动路线类
  class MoveRoute

    # 移动指令列表
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
        next if movecommand == nil
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
      @list.each do |movecommand|
        movecommand.inject_to(moveroute.list[movecommand.index])
      end
    end

    # 提取所有的字符串
    #
    # @return [Array<String>]
    def ex_strings
      strings = []
      @list.each do |movecommand|
        strings.concat(movecommand.ex_strings)
      end
      strings
    end

    # 将所有的字符串替换为指定的字符串
    #
    # @param hash [Hash<String, String>] 字符串翻译表
    #
    # @return [void]
    def in_strings(hash)
      @list.each do |movecommand|
        movecommand.in_strings(hash)
      end
    end

    # 判断是否为空
    #
    # @return [Boolean]
    def empty?
      @list.empty?
    end
  end

  # 事件指令类
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
    # @note 当 '@code' 为 102 时, parameter 是一个字符串数组
    #
    # @return [String] if @code != 102
    # @return [Array<String>] if @code == 102
    attr_accessor :parameter

    # 用 RPG::EventCommand 初始化
    #
    # @param eventcommand [RPG::EventCommand] 待处理的 RPG::EventCommand 对象
    # @param index [Integer] 在原始数组中的索引
    #
    # @return [R3EXS::EventCommand]
    def initialize(eventcommand, index)
      case eventcommand.code
      when 102 # ShowChoices
        @index = index
        @code = 102
        @usage = Utils::EVENT_COMMANDS[102]
        @parameter = eventcommand.parameters[0]
      when 108 # Comment
        @index = index
        @code = 108
        @usage = Utils::EVENT_COMMANDS[108]
        @parameter = eventcommand.parameters[0]
      when 111 # ConditionalBranch
        @index = index
        @code = 111
        @usage = Utils::EVENT_COMMANDS[111]
        if eventcommand.parameters[0] == 4 && eventcommand.parameters[2] == 1
          @parameter = eventcommand.parameters[3]
        elsif eventcommand.parameters[0] == 12
          @parameter = eventcommand.parameters[1]
        else
          @index = -1
        end
      when 118 # Label
        @index = index
        @code = 118
        @usage = Utils::EVENT_COMMANDS[118]
        @parameter = eventcommand.parameters[0]
      when 119 # JumpToLabel
        @index = index
        @code = 119
        @usage = Utils::EVENT_COMMANDS[119]
        @parameter = eventcommand.parameters[0]
      when 122 # ControlVariables
        if eventcommand.parameters[3] == 4
          @index = index
          @code = 122
          @usage = Utils::EVENT_COMMANDS[122]
          @parameter = eventcommand.parameters[4]
        else
          @index = -1
        end
      when 205 # SetMoveRoute
        moveroute_r3exs = R3EXS::MoveRoute.new(eventcommand.parameters[1])
        if moveroute_r3exs.empty?
          @index = -1 # 如果 MoveRoute 里面没有可提取的 MoveCommand ，就将索引设为-1，empty? 将据此判断是否为空
        else
          @index = index
          @code = 205
          @usage = Utils::EVENT_COMMANDS[205]
          @parameter = moveroute_r3exs
        end
      when 320 # ChangeActorName
        @index = index
        @code = 320
        @usage = Utils::EVENT_COMMANDS[320]
        @parameter = eventcommand.parameters[1]
      when 324 # ChangeActorNickname
        @index = index
        @code = 324
        @usage = Utils::EVENT_COMMANDS[324]
        @parameter = eventcommand.parameters[1]
      when 355 # Script
        @index = index
        @code = 355
        @usage = Utils::EVENT_COMMANDS[355]
        @parameter = eventcommand.parameters[0]
      when 401 # ShowText
        @index = index
        @code = 401
        @usage = Utils::EVENT_COMMANDS[401]
        @parameter = eventcommand.parameters[0]
      when 402 # When
        @index = index
        @code = 402
        @usage = Utils::EVENT_COMMANDS[402]
        @parameter = eventcommand.parameters[1]
      when 405 # ShowScrollingText
        @index = index
        @code = 405
        @usage = Utils::EVENT_COMMANDS[405]
        @parameter = eventcommand.parameters[0]
      when 408 # CommentMore
        @index = index
        @code = 408
        @usage = Utils::EVENT_COMMANDS[408]
        @parameter = eventcommand.parameters[0]
      when 505 # MoveRoute
        movecommand_r3exs = R3EXS::MoveCommand.new(eventcommand.parameters[0], 0)
        if movecommand_r3exs.empty?
          @index = -1
        else
          @index = index
          @code = 505
          @usage = Utils::EVENT_COMMANDS[505]
          @parameter = movecommand_r3exs
        end
      when 655 # ScriptMore
        @index = index
        @code = 655
        @usage = Utils::EVENT_COMMANDS[655]
        @parameter = eventcommand.parameters[0]
      else
        @index = -1 # 如果不是以上的事件指令，就将索引设为-1，empty? 将据此判断是否为空
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
        eventcommand.parameters[0] = @parameter
      when 111 # ConditionalBranch
        if eventcommand.parameters[0] == 4 && eventcommand.parameters[2] == 1
          eventcommand.parameters[3] = @parameter
        elsif eventcommand.parameters[0] == 12
          eventcommand.parameters[1] = @parameter
        end
      when 118 # Label
        eventcommand.parameters[0] = @parameter
      when 119 # JumpToLabel
        eventcommand.parameters[0] = @parameter
      when 122 # ControlVariables
        eventcommand.parameters[4] = @parameter
      when 205 # SetMoveRoute
        @parameter.inject_to(eventcommand.parameters[1])
      when 320 # ChangeActorName
        eventcommand.parameters[1] = @parameter
      when 324 # ChangeActorNickname
        eventcommand.parameters[1] = @parameter
      when 355 # Script
        eventcommand.parameters[0] = @parameter
      when 401 # ShowText
        eventcommand.parameters[0] = @parameter
      when 402 # When
        eventcommand.parameters[1] = @parameter
      when 405 # ShowScrollingText
        eventcommand.parameters[0] = @parameter
      when 408 # CommentMore
        eventcommand.parameters[0] = @parameter
      when 505 # MoveRoute
        @parameter.inject_to(eventcommand.parameters[0])
      when 655 # ScriptMore
        eventcommand.parameters[0] = @parameter
      else
        puts "Unknown code: #{eventcommand.code}"
      end
    end

    # 提取所有的字符串
    #
    # @return [Array<String>]
    def ex_strings
      case @code
      when 102 # ShowChoices 是一个特殊的事件指令，它的参数是一个数组
        @parameter
      when 108, 111, 118, 119, 122, 320, 324, 355, 401, 402, 405, 408, 655
        [@parameter]
      when 205
        @parameter.ex_strings
      when 505
        @parameter.ex_strings
      else
        puts "Unknown code: #{@code}"
        []
      end
    end

    # 将所有的字符串替换为指定的字符串
    #
    # @param hash [Hash<String, String>] 字符串翻译表
    #
    # @return [void]
    def in_strings(hash)
      case @code
      when 102 # ShowChoices 是一个特殊的事件指令，它的参数是一个数组
        @parameter.map! { |string| hash[string] || string }
      when 108, 111, 118, 119, 122, 320, 324, 355, 401, 402, 405, 408, 655
        @parameter = hash[@parameter] || @parameter
      when 205
        @parameter.in_strings(hash)
      when 505
        @parameter.in_strings(hash)
      else
        puts "Unknown code: #{@code}"
      end
    end

    # 判断是否为空
    #
    # @return [Boolean]
    def empty?
      @index == -1
    end
  end

  # 公共事件类
  class CommonEvent

    # 在原始数组中的索引
    #
    # @return [Integer]
    attr_accessor :index

    # 公共事件名称
    #
    # @return [String]
    attr_accessor :name

    # 事件指令列表
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
        next if eventcommand == nil
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
      @list.each do |eventcommand|
        eventcommand.inject_to(commonevent.list[eventcommand.index])
      end
    end

    # 提取所有的字符串
    #
    # @return [Array<String>]
    def ex_strings
      strings = [@name]
      @list.each do |eventcommand|
        strings.concat(eventcommand.ex_strings)
      end
      strings
    end

    # 将所有的字符串替换为指定的字符串
    #
    # @param hash [Hash<String, String>] 字符串翻译表
    #
    # @return [void]
    def in_strings(hash)
      @name = hash[@name] || @name
      @list.each do |eventcommand|
        eventcommand.in_strings(hash)
      end
    end

    # 判断是否为空
    #
    # @return [Boolean]
    def empty?
      @name.to_s.empty? && @list.empty?
    end
  end

  # 敌人类
  class Enemy < BaseItem

    # 用 RPG::Enemy 初始化
    #
    # @param enemy [RPG::Enemy] 待处理的 RPG::Enemy 对象
    # @param index [Integer] 在原始数组中的索引
    # @param with_note [Boolean] 是否处理 note 字段
    #
    # @return [R3EXS::Enemy]
    def initialize(enemy, index, with_note)
      super(enemy, index, with_note)
      self.remove_instance_variable(:@description)
    end

    # 注入到 RPG::Enemy 对象
    #
    # @param enemy [RPG::Enemy] 待注入的 RPG::Enemy 对象
    #
    # @return [void]
    def inject_to(enemy)
      super
    end

    # 提取所有的字符串
    #
    # @return [Array<String>]
    def ex_strings
      super
    end

    # 将所有的字符串替换为指定的字符串
    #
    # @param hash [Hash<String, String>] 字符串翻译表
    #
    # @return [void]
    def in_strings(hash)
      super(hash)
    end

    # 判断是否为空
    #
    # @return [Boolean]
    def empty?
      super
    end
  end

  # 可使用物品类
  class UsableItem < BaseItem

    # 用 RPG::UsableItem 初始化
    #
    # @param usableitem [RPG::UsableItem] 待处理的 RPG::UsableItem 对象
    # @param index [Integer] 在原始数组中的索引
    # @param with_note [Boolean] 是否处理 note 字段
    #
    # @return [R3EXS::UsableItem]
    def initialize(usableitem, index, with_note)
      super(usableitem, index, with_note)
    end

    # 注入到 RPG::UsableItem 对象
    #
    # @param usableitem [RPG::UsableItem] 待注入的 RPG::UsableItem 对象
    #
    # @return [void]
    def inject_to(usableitem)
      super
    end

    # 提取所有的字符串
    #
    # @return [Array<String>]
    def ex_strings
      super
    end

    # 将所有的字符串替换为指定的字符串
    #
    # @param hash [Hash<String, String>] 字符串翻译表
    #
    # @return [void]
    def in_strings(hash)
      super(hash)
    end

    # 判断是否为空
    #
    # @return [Boolean]
    def empty?
      super
    end
  end

  # 物品类
  class Item < UsableItem

    # 用 RPG::Item 初始化
    #
    # @param item [RPG::Item] 待处理的 RPG::Item 对象
    # @param index [Integer] 在原始数组中的索引
    # @param with_note [Boolean] 是否处理 note 字段
    #
    # @return [R3EXS::Item]
    def initialize(item, index, with_note)
      super(item, index, with_note)
    end

    # 注入到 RPG::Item 对象
    #
    # @param item [RPG::Item] 待注入的 RPG::Item 对象
    #
    # @return [void]
    def inject_to(item)
      super
    end

    # 提取所有的字符串
    #
    # @return [Array<String>]
    def ex_strings
      super
    end

    # 将所有的字符串替换为指定的字符串
    #
    # @param hash [Hash<String, String>] 字符串翻译表
    #
    # @return [void]
    def in_strings(hash)
      super(hash)
    end

    # 判断是否为空
    #
    # @return [Boolean]
    def empty?
      super
    end
  end

  # 事件类
  class Event

    # 在原始哈希表中的键
    #
    # @return [Integer]
    attr_accessor :index

    # 事件名称
    #
    # @return [String]
    attr_accessor :name

    # 事件页列表
    #
    # @return [Array<R3EXS::Event::Page>]
    attr_accessor :pages

    # 事件页类
    class Page

      # 在原始数组中的索引
      #
      # @return [Integer]
      attr_accessor :index

      # 事件指令列表
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
          next if eventcommand == nil
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
        @list.each do |eventcommand|
          eventcommand.inject_to(page.list[eventcommand.index])
        end
      end

      # 提取所有的字符串
      #
      # @return [Array<String>]
      def ex_strings
        strings = []
        @list.each do |eventcommand|
          strings.concat(eventcommand.ex_strings)
        end
        strings
      end

      # 将所有的字符串替换为指定的字符串
      #
      # @param hash [Hash<String, String>] 字符串翻译表
      #
      # @return [void]
      def in_strings(hash)
        @list.each do |eventcommand|
          eventcommand.in_strings(hash)
        end
      end

      # 判断是否为空
      #
      # @return [Boolean]
      def empty?
        @list.empty?
      end
    end

    # 用 RPG::Event 初始化
    #
    # @param event [RPG::Event] 待处理的 RPG::Event 对象
    # @param index [Integer] 在原始哈希表中的键
    #
    # @return [R3EXS::Event]
    def initialize(event, index)
      @index = index
      @name = event.name
      @pages = []
      event.pages.each_with_index do |page, page_index|
        next if page == nil
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
      @pages.each do |page|
        page.inject_to(event.pages[page.index])
      end
    end

    # 提取所有的字符串
    #
    # @return [Array<String>]
    def ex_strings
      strings = [@name]
      @pages.each do |page|
        strings.concat(page.ex_strings)
      end
      strings
    end

    # 将所有的字符串替换为指定的字符串
    #
    # @param hash [Hash<String, String>] 字符串翻译表
    #
    # @return [void]
    def in_strings(hash)
      @name = hash[@name] || @name
      @pages.each do |page|
        page.in_strings(hash)
      end
    end

    # 判断是否为空
    #
    # @return [Boolean]
    def empty?
      @name.to_s.empty? && @pages.empty?
    end
  end

  # 地图类
  class Map

    # 地图显示名称
    #
    # @return [String]
    attr_accessor :display_name

    # 地图注释
    #
    # @return [String]
    attr_accessor :note

    # 事件列表
    #
    # @return [Array<R3EXS::Event>]
    attr_accessor :events

    # 用 RPG::Map 初始化
    #
    # @param map [RPG::Map] 待处理的 RPG::Map 对象
    # @param with_note [Boolean] 是否处理 note 字段
    #
    # @return [R3EXS::Map]
    def initialize(map, with_note)
      @display_name = map.display_name
      @note = map.note
      @events = []
      map.events.each do |key, event|
        next if event == nil
        event_r3exs = R3EXS::Event.new(event, key)
        @events << event_r3exs unless event_r3exs.empty?
      end
      self.remove_instance_variable(:@note) unless with_note
    end

    # 注入到 RPG::Map 对象
    #
    # @param map [RPG::Map] 待注入的 RPG::Map 对象
    #
    # @return [void]
    def inject_to(map)
      map.display_name = @display_name
      map.note = @note if self.instance_variable_defined?(:@note)
      @events.each do |event|
        event.inject_to(map.events[event.index])
      end
    end

    # 提取所有的字符串
    #
    # @return [Array<String>]
    def ex_strings
      strings = []
      strings << @display_name
      strings << @note if self.instance_variable_defined?(:@note)
      @events.each do |event|
        strings.concat(event.ex_strings)
      end
      strings
    end

    # 将所有的字符串替换为指定的字符串
    #
    # @param hash [Hash<String, String>] 字符串翻译表
    #
    # @return [void]
    def in_strings(hash)
      @display_name = hash[@display_name] || @display_name
      @note = hash[@note] || @note if self.instance_variable_defined?(:@note)
      @events.each do |event|
        event.in_strings(hash)
      end
    end
  end

  # 地图信息类
  class MapInfo

    # 在原始哈希表中的键
    #
    # @return [Integer]
    attr_accessor :index

    # 地图内部名称
    #
    # @return [String]
    attr_accessor :name

    # 用 RPG::MapInfo 初始化
    #
    # @param mapinfo [RPG::MapInfo] 待处理的 RPG::MapInfo 对象
    # @param index [Integer] 在原始哈希表中的键
    #
    # @return [R3EXS::MapInfo]
    def initialize(mapinfo, index, _unused = nil)
      @index = index
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
    # @param hash [Hash<String, String>] 字符串翻译表
    #
    # @return [void]
    def in_strings(hash)
      @name = hash[@name] || @name
    end
  end

  # 技能类
  class Skill < UsableItem

    # 技能使用时的消息
    #
    # @return [String]
    attr_accessor :message1

    # 技能使用时的消息
    #
    # @return [String]
    attr_accessor :message2

    # 用 RPG::Skill 初始化
    #
    # @param skill [RPG::Skill] 待处理的 RPG::Skill 对象
    # @param index [Integer] 在原始数组中的索引
    # @param with_note [Boolean] 是否处理 note 字段
    #
    # @return [R3EXS::Skill]
    def initialize(skill, index, with_note)
      super(skill, index, with_note)
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
    # @param hash [Hash<String, String>] 字符串翻译表
    #
    # @return [void]
    def in_strings(hash)
      super(hash)
      @message1 = hash[@message1] || @message1
      @message2 = hash[@message2] || @message2
    end

    # 判断是否为空
    #
    # @return [Boolean]
    def empty?
      super && @message1.to_s.empty? && @message2.to_s.empty?
    end
  end

  # 状态类
  class State < BaseItem

    # 状态应用队员时的消息
    #
    # @return [String]
    attr_accessor :message1

    # 状态应用敌人时的消息
    #
    # @return [String]
    attr_accessor :message2

    # 状态保持时的消息
    #
    # @return [String]
    attr_accessor :message3

    # 状态解除时的消息
    #
    # @return [String]
    attr_accessor :message4

    # 用 RPG::State 初始化
    #
    # @param state [RPG::State] 待处理的 RPG::State 对象
    # @param index [Integer]  在原始数组中的索引
    # @param with_note [Boolean] 是否处理 note 字段
    #
    # @return [R3EXS::State]
    def initialize(state, index, with_note)
      super(state, index, with_note)
      @message1 = state.message1
      @message2 = state.message2
      @message3 = state.message3
      @message4 = state.message4
      self.remove_instance_variable(:@description)
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
    # @param hash [Hash<String, String>] 字符串翻译表
    #
    # @return [void]
    def in_strings(hash)
      super(hash)
      @message1 = hash[@message1] || @message1
      @message2 = hash[@message2] || @message2
      @message3 = hash[@message3] || @message3
      @message4 = hash[@message4] || @message4
    end

    # 判断是否为空
    #
    # @return [Boolean]
    def empty?
      super && @message1.to_s.empty? && @message2.to_s.empty? && @message3.to_s.empty? && @message4.to_s.empty?
    end
  end

  # 系统类
  class System

    # 游戏标题
    #
    # @return [String]
    attr_accessor :game_title

    # 货币单位
    #
    # @return [String]
    attr_accessor :currency_unit

    # 属性名称
    #
    # @return [Array<String>]
    attr_accessor :elements

    # 技能类型名称
    #
    # @return [Array<String>]
    attr_accessor :skill_types

    # 武器类型名称
    #
    # @return [Array<String>]
    attr_accessor :weapon_types

    # 防具类型名称
    #
    # @return [Array<String>]
    attr_accessor :armor_types

    # 开关名称
    #
    # @return [Array<String>]
    attr_accessor :switches

    # 变量名称
    #
    # @return [Array<String>]
    attr_accessor :variables

    # 系统术语
    #
    # @return [R3EXS::System::Terms]
    attr_accessor :terms

    # 术语类
    class Terms

      # 基本术语
      #
      # @return [Array<String>]
      attr_accessor :basic

      # 属性名称
      #
      # @return [Array<String>]
      attr_accessor :params

      # 装备类型名称
      #
      # @return [Array<String>]
      attr_accessor :etypes

      # 命令名称
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
        strings = []
        strings.concat(@basic)
        strings.concat(@params)
        strings.concat(@etypes)
        strings.concat(@commands)
        strings
      end

      # 将所有的字符串替换为指定的字符串
      #
      # @param hash [Hash<String, String>] 字符串翻译表
      #
      # @return [void]
      def in_strings(hash)
        @basic.map! { |string| hash[string] || string }
        @params.map! { |string| hash[string] || string }
        @etypes.map! { |string| hash[string] || string }
        @commands.map! { |string| hash[string] || string }
      end
    end

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
      strings = []
      strings << @game_title
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
    # @param hash [Hash<String, String>] 字符串翻译表
    #
    # @return [void]
    def in_strings(hash)
      @game_title = hash[@game_title] || @game_title
      @currency_unit = hash[@currency_unit] || @currency_unit
      @elements.map! { |string| hash[string] || string }
      @skill_types.map! { |string| hash[string] || string }
      @weapon_types.map! { |string| hash[string] || string }
      @armor_types.map! { |string| hash[string] || string }
      @switches.map! { |string| hash[string] || string }
      @variables.map! { |string| hash[string] || string }
      @terms.in_strings(hash)
    end
  end

  # 图块类
  class Tileset

    # 在原始数组中的索引
    #
    # @return [Integer]
    attr_accessor :index

    # 图块名称
    #
    # @return [String]
    attr_accessor :name

    # 图块注释
    #
    # @return [String]
    attr_accessor :note

    # 用 RPG::Tileset 初始化
    #
    # @param tileset [RPG::Tileset] 待处理的 RPG::Tileset 对象
    # @param index [Integer] 在原始数组中的索引
    # @param with_note [Boolean] 是否处理 note 字段
    #
    # @return [R3EXS::Tileset]
    def initialize(tileset, index, with_note)
      @index = index
      @name = tileset.name
      @note = tileset.note
      self.remove_instance_variable(:@note) unless with_note
    end

    # 注入到 RPG::Tileset 对象
    #
    # @param tileset [RPG::Tileset] 待注入的 RPG::Tileset 对象
    #
    # @return [void]
    def inject_to(tileset)
      tileset.name = @name
      tileset.note = @note if self.instance_variable_defined?(:@note)
    end

    # 提取所有的字符串
    #
    # @return [Array<String>]
    def ex_strings
      strings = []
      strings << @name
      strings << @note if self.instance_variable_defined?(:@note)
      strings
    end

    # 将所有的字符串替换为指定的字符串
    #
    # @param hash [Hash<String, String>] 字符串翻译表
    #
    # @return [void]
    def in_strings(hash)
      @name = hash[@name] || @name
      @note = hash[@note] || @note if self.instance_variable_defined?(:@note)
    end

    # 判断是否为空
    #
    # @return [Boolean]
    def empty?
      @name.to_s.empty? && @note.to_s.empty?
    end
  end

  # 敌群类
  class Troop

    # 在原始数组中的索引
    #
    # @return [Integer]
    attr_accessor :index

    # 敌群名称
    #
    # @return [String]
    attr_accessor :name

    # 敌群页列表
    #
    # @return [Array<R3EXS::Troop::Page>]
    attr_accessor :pages

    # 敌群页类
    class Page

      # 在原始数组中的索引
      #
      # @return [Integer]
      attr_accessor :index

      # 事件指令列表
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
          next if eventcommand == nil
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
        @list.each do |eventcommand|
          eventcommand.inject_to(page.list[eventcommand.index])
        end
      end

      # 提取所有的字符串
      #
      # @return [Array<String>]
      def ex_strings
        strings = []
        @list.each do |eventcommand|
          strings.concat(eventcommand.ex_strings)
        end
        strings
      end

      # 将所有的字符串替换为指定的字符串
      #
      # @param hash [Hash<String, String>] 字符串翻译表
      #
      # @return [void]
      def in_strings(hash)
        @list.each do |eventcommand|
          eventcommand.in_strings(hash)
        end
      end

      # 判断是否为空
      #
      # @return [Boolean]
      def empty?
        @list.empty?
      end
    end

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
        next if page == nil
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
      @pages.each do |page|
        page.inject_to(troop.pages[page.index])
      end
    end

    # 提取所有的字符串
    #
    # @return [Array<String>]
    def ex_strings
      strings = [@name]
      @pages.each do |page|
        strings.concat(page.ex_strings)
      end
      strings
    end

    # 将所有的字符串替换为指定的字符串
    #
    # @param hash [Hash<String, String>] 字符串翻译表
    #
    # @return [void]
    def in_strings(hash)
      @name = hash[@name] || @name
      @pages.each do |page|
        page.in_strings(hash)
      end
    end

    # 判断是否为空
    #
    # @return [Boolean]
    def empty?
      @name.to_s.empty? && @pages.empty?
    end
  end

  # 武器类
  class Weapon < EquipItem

    # 用 RPG::Weapon 初始化
    #
    # @param weapon [RPG::Weapon] 待处理的 RPG::Weapon 对象
    # @param index [Integer] 在原始数组中的索引
    # @param with_note [Boolean] 是否处理 note 字段
    #
    # @return [R3EXS::Weapon]
    def initialize(weapon, index, with_note)
      super(weapon, index, with_note)
    end

    # 注入到 RPG::Weapon 对象
    #
    # @param weapon [RPG::Weapon] 待注入的 RPG::Weapon 对象
    #
    # @return [void]
    def inject_to(weapon)
      super
    end

    # 提取所有的字符串
    #
    # @return [Array<String>]
    def ex_strings
      super
    end

    # 将所有的字符串替换为指定的字符串
    #
    # @param hash [Hash<String, String>] 字符串翻译表
    #
    # @return [void]
    def in_strings(hash)
      super(hash)
    end

    # 判断是否为空
    #
    # @return [Boolean]
    def empty?
      super
    end
  end

end
