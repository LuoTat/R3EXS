# frozen_string_literal: true
require_relative 'RGSS3'

module R3EXS

    class BaseItem

        # 用RPG::BaseItem初始化
        # @param baseitem [RPG::BaseItem]
        # @param index [Integer]
        # @param with_note [Boolean]
        # @return [R3EXS::BaseItem]
        def initialize(baseitem, index, with_note)
            @index = index
            @name = baseitem.name
            @description = baseitem.description
            @note = baseitem.note
            self.remove_instance_variable(:@note) unless with_note
        end

        # 注入到目标对象
        # @param baseitem [RPG::BaseItem]
        # @return [Void]
        def inject_to(baseitem)
            baseitem.name = @name
            baseitem.description = @description
            baseitem.note = @note if self.instance_variable_defined?(:@note)
        end

        # 提取所有的字符串
        # @return [Array<String>]
        def ex_strings
            strings = []
            strings << @name
            strings << @description
            strings << @note if self.instance_variable_defined?(:@note)
            strings
        end

        # 将所有的字符串替换为指定的字符串
        # @param hash [Hash]
        # @return [Void]
        def in_strings(hash)
            @name = hash[@name] || @name
            @description = hash[@description] || @description
            @note = hash[@note] || @note if self.instance_variable_defined?(:@note)
        end

        # 判断是否为空
        # @return [Boolean]
        def empty?
            @name.to_s.empty? && @description.to_s.empty? && @note.to_s.empty?
        end

        attr_accessor :index
        attr_accessor :name
        attr_accessor :description
        attr_accessor :note
    end

    class Actor < BaseItem

        # 用RPG::Actor初始化
        # @param actor [RPG::Actor]
        # @param index [Integer]
        # @param with_note [Boolean]
        # @return [R3EXS::Actor]
        def initialize(actor, index, with_note)
            super(actor, index, with_note)
            @nickname = actor.nickname
        end

        # 注入到目标对象
        # @param actor [RPG::Actor]
        # @return [Void]
        def inject_to(actor)
            super(actor)
            actor.nickname = @nickname
        end

        # 提取所有的字符串
        # @return [Array<String>]
        def ex_strings
            strings = super
            strings << @nickname
            strings
        end

        # 将所有的字符串替换为指定的字符串
        # @param hash [Hash]
        # @return [Void]
        def in_strings(hash)
            super(hash)
            @nickname = hash[@nickname] || @nickname
        end

        # 判断是否为空
        # @return [Boolean]
        def empty?
            super && @nickname.to_s.empty?
        end

        attr_accessor :nickname
    end

    class Animation

        # 用RPG::Animation初始化
        # @param animation [RPG::Animation]
        # @param index [Integer]
        # @return [R3EXS::Animation]
        def initialize(animation, index, _unused = nil)
            @index = index
            @name = animation.name
        end

        # 注入到目标对象
        # @param animation [RPG::Animation]
        # @return [Void]
        def inject_to(animation)
            animation.name = @name
        end

        # 提取所有的字符串
        # @return [Array<String>]
        def ex_strings
            [@name]
        end

        # 将所有的字符串替换为指定的字符串
        # @param hash [Hash]
        # @return [Void]
        def in_strings(hash)
            @name = hash[@name] || @name
        end

        # 判断是否为空
        # @return [Boolean]
        def empty?
            @name.to_s.empty?
        end

        attr_accessor :index
        attr_accessor :name
    end

    class EquipItem < BaseItem

        # 用RPG::EquipItem初始化
        # @param equipitem [RPG::EquipItem]
        # @param index [Integer]
        # @param with_note [Boolean]
        # @return [R3EXS::EquipItem]
        def initialize(equipitem, index, with_note)
            super(equipitem, index, with_note)
        end

        # 注入到目标对象
        # @param equipitem [RPG::EquipItem]
        # @return [Void]
        def inject_to(equipitem)
            super
        end

        # 提取所有的字符串
        # @return [Array<String>]
        def ex_strings
            super
        end

        # 将所有的字符串替换为指定的字符串
        # @param hash [Hash]
        # @return [Void]
        def in_strings(hash)
            super(hash)
        end

        # 判断是否为空
        # @return [Boolean]
        def empty?
            super
        end

    end

    class Armor < EquipItem

        # 用RPG::Armor初始化
        # @param armor [RPG::Armor]
        # @param index [Integer]
        # @param with_note [Boolean]
        # @return [R3EXS::Armor]
        def initialize(armor, index, with_note)
            super(armor, index, with_note)
        end

        # 注入到目标对象
        # @param armor [RPG::Armor]
        # @return [Void]
        def inject_to(armor)
            super
        end

        # 提取所有的字符串
        # @return [Array<String>]
        def ex_strings
            super
        end

        # 将所有的字符串替换为指定的字符串
        # @param hash [Hash]
        # @return [Void]
        def in_strings(hash)
            super(hash)
        end

        # 判断是否为空
        # @return [Boolean]
        def empty?
            super
        end

    end

    class Class < BaseItem

        class Learning

            # 用RPG::Class::Learning初始化
            # @param learning [RPG::Class::Learning]
            # @param index [Integer]
            # @return [R3EXS::Class::Learning]
            def initialize(learning, index)
                @index = index
                @note = learning.note
            end

            # 注入到目标对象
            # @param learning [RPG::Class::Learning]
            # @return [Void]
            def inject_to(learning)
                learning.note = @note
            end

            # 提取所有的字符串
            # @return [Array<String>]
            def ex_strings
                [@note]
            end

            # 将所有的字符串替换为指定的字符串
            # @param hash [Hash]
            # @return [Void]
            def in_strings(hash)
                @note = hash[@note] || @note
            end

            # 判断是否为空
            # @return [Boolean]
            def empty?
                @note.to_s.empty?
            end

            attr_accessor :index
            attr_accessor :note
        end

        # 用RPG::Class初始化
        # @param klass [RPG::Class]
        # @param index [Integer]
        # @param with_note [Boolean]
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

        # 注入到目标对象
        # @param klass [RPG::Class]
        # @return [Void]
        def inject_to(klass)
            super(klass)
            if self.instance_variable_defined?(:@learnings)
                @learnings.each do |learning|
                    learning.inject_to(klass.learnings[learning.index])
                end
            end
        end

        # 提取所有的字符串
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
        # @param hash [Hash]
        # @return [Void]
        def in_strings(hash)
            super(hash)
            if self.instance_variable_defined?(:@learnings)
                @learnings.each do |learning|
                    learning.in_strings(hash)
                end
            end
        end

        # 判断是否为空
        # @return [Boolean]
        def empty?
            super && @learnings.to_a.empty?
        end

        attr_accessor :learnings
    end

    class MoveCommand

        # 用RPG::MoveCommand初始化
        # @param movecommand [RPG::MoveCommand]
        # @param index [Integer]
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

        # 注入到目标对象
        # @param movecommand [RPG::MoveCommand]
        # @return [Void]
        def inject_to(movecommand)
            movecommand.parameters[0] = @parameter
        end

        # 提取所有的字符串
        # @return [Array<String>]
        def ex_strings
            [@parameter]
        end

        # 将所有的字符串替换为指定的字符串
        # @param hash [Hash]
        # @return [Void]
        def in_strings(hash)
            @parameter = hash[@parameter] || @parameter
        end

        # 判断是否为空
        # @return [Boolean]
        def empty?
            @index == -1
        end

        attr_accessor :index
        attr_accessor :code
        attr_accessor :usage
        attr_accessor :parameter
    end

    class MoveRoute

        # 用RPG::MoveRoute初始化
        # @param moveroute [RPG::MoveRoute]
        # @return [R3EXS::MoveRoute]
        def initialize(moveroute)
            @list = []
            moveroute.list.each_with_index do |movecommand, index|
                next if movecommand == nil
                movecommand_r3exs = R3EXS::MoveCommand.new(movecommand, index)
                @list << movecommand_r3exs unless movecommand_r3exs.empty?
            end
        end

        # 注入到目标对象
        # @param moveroute [RPG::MoveRoute]
        # @return [Void]
        def inject_to(moveroute)
            @list.each do |movecommand|
                movecommand.inject_to(moveroute.list[movecommand.index])
            end
        end

        # 提取所有的字符串
        # @return [Array<String>]
        def ex_strings
            strings = []
            @list.each do |movecommand|
                strings.concat(movecommand.ex_strings)
            end
            strings
        end

        # 将所有的字符串替换为指定的字符串
        # @param hash [Hash]
        # @return [Void]
        def in_strings(hash)
            @list.each do |movecommand|
                movecommand.in_strings(hash)
            end
        end

        # 判断是否为空
        # @return [Boolean]
        def empty?
            @list.empty?
        end

        attr_accessor :list
    end

    class EventCommand

        # 用RPG::EventCommand初始化
        # @param eventcommand [RPG::EventCommand]
        # @param index [Integer]
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
                @index = index
                @code = 205
                @usage = Utils::EVENT_COMMANDS[205]
                moveroute_r3exs = R3EXS::MoveRoute.new(eventcommand.parameters[1])
                @parameter = moveroute_r3exs.list unless moveroute_r3exs.empty?
                if @parameter.nil?
                    @index = -1 # 如果没有可提取的 MoveCommand ，就将索引设为-1，empty?将据此判断是否为空
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
                if eventcommand.parameters[0].code == 45
                    @index = index
                    @code = 505
                    @usage = Utils::EVENT_COMMANDS[505]
                    @parameter = eventcommand.parameters[0].parameters[0]
                else
                    @index = -1
                end
            when 655 # ScriptMore
                @index = index
                @code = 655
                @usage = Utils::EVENT_COMMANDS[655]
                @parameter = eventcommand.parameters[0]
            else
                @index = -1 # 如果不是以上的事件指令，就将索引设为-1，empty?将据此判断是否为空
            end
        end

        # 注入到目标对象
        # @param eventcommand [RPG::EventCommand]
        # @return [Void]
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
                eventcommand.parameters[0].parameters[0] = @parameter
            when 655 # ScriptMore
                eventcommand.parameters[0] = @parameter
            else
                puts "Unknown code: #{eventcommand.code}"
            end
        end

        # 提取所有的字符串
        # @return [Array<String>]
        def ex_strings
            case @code
            when 102 # ShowChoices 是一个特殊的事件指令，它的参数是一个数组
                @parameter
            when 108, 111, 118, 119, 122, 320, 324, 355, 401, 402, 405, 408, 655
                [@parameter]
            when 205
                @parameter.ex_strings
            else
                puts "Unknown code: #{@code}"
                []
            end
        end

        # 将所有的字符串替换为指定的字符串
        # @param hash [Hash]
        # @return [Void]
        def in_strings(hash)
            case @code
            when 102 # ShowChoices 是一个特殊的事件指令，它的参数是一个数组
                @parameter.map! { |string| hash[string] || string }
            when 108, 111, 118, 119, 122, 320, 324, 355, 401, 402, 405, 408, 655
                @parameter = hash[@parameter] || @parameter
            when 205
                @parameter.in_strings(hash)
            else
                puts "Unknown code: #{@code}"
            end
        end

        # 判断是否为空
        # @return [Boolean]
        def empty?
            @index == -1
        end

        attr_accessor :index
        attr_accessor :code
        attr_accessor :usage
        attr_accessor :parameter
    end

    class CommonEvent

        # 用RPG::CommonEvent初始化
        # @param commonevent [RPG::CommonEvent]
        # @param index [Integer]
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

        # 注入到目标对象
        # @param commonevent [RPG::CommonEvent]
        # @return [Void]
        def inject_to(commonevent)
            commonevent.name = @name
            @list.each do |eventcommand|
                eventcommand.inject_to(commonevent.list[eventcommand.index])
            end
        end

        # 提取所有的字符串
        # @return [Array<String>]
        def ex_strings
            strings = [@name]
            @list.each do |eventcommand|
                strings.concat(eventcommand.ex_strings)
            end
            strings
        end

        # 将所有的字符串替换为指定的字符串
        # @param hash [Hash]
        # @return [Void]
        def in_strings(hash)
            @name = hash[@name] || @name
            @list.each do |eventcommand|
                eventcommand.in_strings(hash)
            end
        end

        # 判断是否为空
        # @return [Boolean]
        def empty?
            @name.to_s.empty? && @list.empty?
        end

        attr_accessor :index
        attr_accessor :name
        attr_accessor :list
    end

    class Enemy < BaseItem

        # 用RPG::Enemy初始化
        # @param enemy [RPG::Enemy]
        # @param index [Integer]
        # @param with_note [Boolean]
        # @return [R3EXS::Enemy]
        def initialize(enemy, index, with_note)
            super(enemy, index, with_note)
            self.remove_instance_variable(:@description)
        end

        # 注入到目标对象
        # @param enemy [RPG::Enemy]
        # @return [Void]
        def inject_to(enemy)
            super
        end

        # 提取所有的字符串
        # @return [Array<String>]
        def ex_strings
            super
        end

        # 将所有的字符串替换为指定的字符串
        # @param hash [Hash]
        # @return [Void]
        def in_strings(hash)
            super(hash)
        end

        # 判断是否为空
        # @return [Boolean]
        def empty?
            super
        end

    end

    class UsableItem < BaseItem

        # 用RPG::UsableItem初始化
        # @param usableitem [RPG::UsableItem]
        # @param index [Integer]
        # @param with_note [Boolean]
        # @return [R3EXS::UsableItem]
        def initialize(usableitem, index, with_note)
            super(usableitem, index, with_note)
        end

        # 注入到目标对象
        # @param usableitem [RPG::UsableItem]
        # @return [Void]
        def inject_to(usableitem)
            super
        end

        # 提取所有的字符串
        # @return [Array<String>]
        def ex_strings
            super
        end

        # 将所有的字符串替换为指定的字符串
        # @param hash [Hash]
        # @return [Void]
        def in_strings(hash)
            super(hash)
        end

        # 判断是否为空
        # @return [Boolean]
        def empty?
            super
        end
    end

    class Item < UsableItem

        # 用RPG::Item初始化
        # @param item [RPG::Item]
        # @param index [Integer]
        # @param with_note [Boolean]
        # @return [R3EXS::Item]
        def initialize(item, index, with_note)
            super(item, index, with_note)
        end

        # 注入到目标对象
        # @param item [RPG::Item]
        # @return [Void]
        def inject_to(item)
            super
        end

        # 提取所有的字符串
        # @return [Array<String>]
        def ex_strings
            super
        end

        # 将所有的字符串替换为指定的字符串
        # @param hash [Hash]
        # @return [Void]
        def in_strings(hash)
            super(hash)
        end

        # 判断是否为空
        # @return [Boolean]
        def empty?
            super
        end
    end

    class Event

        class Page

            # 用RPG::Event::Page初始化
            # @param page [RPG::Event::Page]
            # @param index [Integer]
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

            # 注入到目标对象
            # @param page [RPG::Event::Page]
            # @return [Void]
            def inject_to(page)
                @list.each do |eventcommand|
                    eventcommand.inject_to(page.list[eventcommand.index])
                end
            end

            # 提取所有的字符串
            # @return [Array<String>]
            def ex_strings
                strings = []
                @list.each do |eventcommand|
                    strings.concat(eventcommand.ex_strings)
                end
                strings
            end

            # 将所有的字符串替换为指定的字符串
            # @param hash [Hash]
            # @return [Void]
            def in_strings(hash)
                @list.each do |eventcommand|
                    eventcommand.in_strings(hash)
                end
            end

            # 判断是否为空
            # @return [Boolean]
            def empty?
                @list.empty?
            end

            attr_accessor :index
            attr_accessor :list
        end

        # 用RPG::Event初始化
        # @param event [RPG::Event]
        # @param index [Integer]
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

        # 注入到目标对象
        # @param event [RPG::Event]
        # @return [Void]
        def inject_to(event)
            event.name = @name
            @pages.each do |page|
                page.inject_to(event.pages[page.index])
            end
        end

        # 提取所有的字符串
        # @return [Array<String>]
        def ex_strings
            strings = [@name]
            @pages.each do |page|
                strings.concat(page.ex_strings)
            end
            strings
        end

        # 将所有的字符串替换为指定的字符串
        # @param hash [Hash]
        # @return [Void]
        def in_strings(hash)
            @name = hash[@name] || @name
            @pages.each do |page|
                page.in_strings(hash)
            end
        end

        # 判断是否为空
        # @return [Boolean]
        def empty?
            @name.to_s.empty? && @pages.empty?
        end

        attr_accessor :index
        attr_accessor :name
        attr_accessor :pages
    end

    class Map

        # 用RPG::Map初始化
        # @param map [RPG::Map]
        # @param with_note [Boolean]
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

        # 注入到目标对象
        # @param map [RPG::Map]
        # @return [Void]
        def inject_to(map)
            map.display_name = @display_name
            map.note = @note if self.instance_variable_defined?(:@note)
            @events.each do |event|
                event.inject_to(map.events[event.index])
            end
        end

        # 提取所有的字符串
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
        # @param hash [Hash]
        # @return [Void]
        def in_strings(hash)
            @display_name = hash[@display_name] || @display_name
            @note = hash[@note] || @note if self.instance_variable_defined?(:@note)
            @events.each do |event|
                event.in_strings(hash)
            end
        end

        attr_accessor :display_name
        attr_accessor :note
        attr_accessor :events
    end

    class MapInfo

        # 用RPG::MapInfo初始化
        # @param mapinfo [RPG::MapInfo]
        # @param index [Integer]
        # @return [R3EXS::MapInfo]
        def initialize(mapinfo, index, _unused = nil)
            @index = index
            @name = mapinfo.name
        end

        # 注入到目标对象
        # @param mapinfo [RPG::MapInfo]
        # @return [Void]
        def inject_to(mapinfo)
            mapinfo.name = @name
        end

        # 提取所有的字符串
        # @return [Array<String>]
        def ex_strings
            [@name]
        end

        # 将所有的字符串替换为指定的字符串
        # @param hash [Hash]
        # @return [Void]
        def in_strings(hash)
            @name = hash[@name] || @name
        end

        attr_accessor :index
        attr_accessor :name
    end

    class Skill < UsableItem

        # 用RPG::Skill初始化
        # @param skill [RPG::Skill]
        # @param index [Integer]
        # @param with_note [Boolean]
        # @return [R3EXS::Skill]
        def initialize(skill, index, with_note)
            super(skill, index, with_note)
            @message1 = skill.message1
            @message2 = skill.message2
        end

        # 注入到目标对象
        # @param skill [RPG::Skill]
        # @return [Void]
        def inject_to(skill)
            super
            skill.message1 = @message1
            skill.message2 = @message2
        end

        # 提取所有的字符串
        # @return [Array<String>]
        def ex_strings
            strings = super
            strings << @message1
            strings << @message2
            strings
        end

        # 将所有的字符串替换为指定的字符串
        # @param hash [Hash]
        # @return [Void]
        def in_strings(hash)
            super(hash)
            @message1 = hash[@message1] || @message1
            @message2 = hash[@message2] || @message2
        end

        # 判断是否为空
        # @return [Boolean]
        def empty?
            super && @message1.to_s.empty? && @message2.to_s.empty?
        end

        attr_accessor :message1
        attr_accessor :message2
    end

    class State < BaseItem

        # 用RPG::State初始化
        # @param index [Integer]
        # @param state [RPG::State]
        # @param with_note [Boolean]
        # @return [R3EXS::State]
        def initialize(state, index, with_note)
            super(state, index, with_note)
            @message1 = state.message1
            @message2 = state.message2
            @message3 = state.message3
            @message4 = state.message4
            self.remove_instance_variable(:@description)
        end

        # 注入到目标对象
        # @param state [RPG::State]
        # @return [Void]
        def inject_to(state)
            super
            state.message1 = @message1
            state.message2 = @message2
            state.message3 = @message3
            state.message4 = @message4
        end

        # 提取所有的字符串
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
        # @param hash [Hash]
        # @return [Void]
        def in_strings(hash)
            super(hash)
            @message1 = hash[@message1] || @message1
            @message2 = hash[@message2] || @message2
            @message3 = hash[@message3] || @message3
            @message4 = hash[@message4] || @message4
        end

        # 判断是否为空
        # @return [Boolean]
        def empty?
            super && @message1.to_s.empty? && @message2.to_s.empty? && @message3.to_s.empty? && @message4.to_s.empty?
        end

        attr_accessor :message1
        attr_accessor :message2
        attr_accessor :message3
        attr_accessor :message4
    end

    class System

        class Terms

            # 用RPG::System::Terms初始化
            # @param terms [RPG::System::Terms]
            # @return [R3EXS::System::Terms]
            def initialize(terms)
                @basic = terms.basic
                @params = terms.params
                @etypes = terms.etypes
                @commands = terms.commands
            end

            # 注入到目标对象
            # @param terms [RPG::System::Terms]
            # @return [Void]
            def inject_to(terms)
                terms.basic = @basic
                terms.params = @params
                terms.etypes = @etypes
                terms.commands = @commands
            end

            # 提取所有的字符串
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
            # @param hash [Hash]
            # @return [Void]
            def in_strings(hash)
                @basic.map! { |string| hash[string] || string }
                @params.map! { |string| hash[string] || string }
                @etypes.map! { |string| hash[string] || string }
                @commands.map! { |string| hash[string] || string }
            end

            attr_accessor :basic
            attr_accessor :params
            attr_accessor :etypes
            attr_accessor :commands
        end

        # 用RPG::System初始化
        # @param system [RPG::System]
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

        # 注入到目标对象
        # @param system [RPG::System]
        # @return [Void]
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
        # @param hash [Hash]
        # @return [Void]
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

        attr_accessor :game_title
        attr_accessor :currency_unit
        attr_accessor :elements
        attr_accessor :skill_types
        attr_accessor :weapon_types
        attr_accessor :armor_types
        attr_accessor :switches
        attr_accessor :variables
        attr_accessor :terms
    end

    class Tileset

        # 用RPG::Tileset初始化
        # @param tileset [RPG::Tileset]
        # @param index [Integer]
        # @param with_note [Boolean]
        # @return [R3EXS::Tileset]
        def initialize(tileset, index, with_note)
            @index = index
            @name = tileset.name
            @note = tileset.note
            self.remove_instance_variable(:@note) unless with_note
        end

        # 注入到目标对象
        # @param tileset [RPG::Tileset]
        # @return [Void]
        def inject_to(tileset)
            tileset.name = @name
            tileset.note = @note if self.instance_variable_defined?(:@note)
        end

        # 提取所有的字符串
        # @return [Array<String>]
        def ex_strings
            strings = []
            strings << @name
            strings << @note if self.instance_variable_defined?(:@note)
            strings
        end

        # 将所有的字符串替换为指定的字符串
        # @param hash [Hash]
        # @return [Void]
        def in_strings(hash)
            @name = hash[@name] || @name
            @note = hash[@note] || @note if self.instance_variable_defined?(:@note)
        end

        # 判断是否为空
        # @return [Boolean]
        def empty?
            @name.to_s.empty? && @note.to_s.empty?
        end

        attr_accessor :index
        attr_accessor :name
        attr_accessor :note
    end

    class Troop

        class Page

            # 用RPG::Troop::Page初始化
            # @param page [RPG::Troop::Page]
            # @param index [Integer]
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

            # 注入到目标对象
            # @param page [RPG::Troop::Page]
            # @return [Void]
            def inject_to(page)
                @list.each do |eventcommand|
                    eventcommand.inject_to(page.list[eventcommand.index])
                end
            end

            # 提取所有的字符串
            # @return [Array<String>]
            def ex_strings
                strings = []
                @list.each do |eventcommand|
                    strings.concat(eventcommand.ex_strings)
                end
                strings
            end

            # 将所有的字符串替换为指定的字符串
            # @param hash [Hash]
            # @return [Void]
            def in_strings(hash)
                @list.each do |eventcommand|
                    eventcommand.in_strings(hash)
                end
            end

            # 判断是否为空
            # @return [Boolean]
            def empty?
                @list.empty?
            end

            attr_accessor :index
            attr_accessor :list
        end

        # 用RPG::Troop初始化
        # @param troop [RPG::Troop]
        # @param index [Integer]
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

        # 注入到目标对象
        # @param troop [RPG::Troop]
        # @return [Void]
        def inject_to(troop)
            troop.name = @name
            @pages.each do |page|
                page.inject_to(troop.pages[page.index])
            end
        end

        # 提取所有的字符串
        # @return [Array<String>]
        def ex_strings
            strings = [@name]
            @pages.each do |page|
                strings.concat(page.ex_strings)
            end
            strings
        end

        # 将所有的字符串替换为指定的字符串
        # @param hash [Hash]
        # @return [Void]
        def in_strings(hash)
            @name = hash[@name] || @name
            @pages.each do |page|
                page.in_strings(hash)
            end
        end

        # 判断是否为空
        # @return [Boolean]
        def empty?
            @name.to_s.empty? && @pages.empty?
        end

        attr_accessor :index
        attr_accessor :name
        attr_accessor :pages
    end

    class Weapon < EquipItem

        # 用RPG::Weapon初始化
        # @param weapon [RPG::Weapon]
        # @param index [Integer]
        # @param with_note [Boolean]
        # @return [R3EXS::Weapon]
        def initialize(weapon, index, with_note)
            super(weapon, index, with_note)
        end

        # 注入到目标对象
        # @param weapon [RPG::Weapon]
        # @return [Void]
        def inject_to(weapon)
            super
        end

        # 提取所有的字符串
        # @return [Array<String>]
        def ex_strings
            super
        end

        # 将所有的字符串替换为指定的字符串
        # @param hash [Hash]
        # @return [Void]
        def in_strings(hash)
            super(hash)
        end

        # 判断是否为空
        # @return [Boolean]
        def empty?
            super
        end
    end

end