require 'oj'
require 'fileutils'
require_relative 'RGSS3'

def in_strings_EventCommandList(eventCommandList)
    eventCommandList.each do |eventCommand|
        case eventCommand.code
        when 102 # 显示选项
            eventCommand.parameters[0].map! do |string|
                next string if string.empty?
                new_string = $all_ex_strings[string]
                string = (new_string.nil? || new_string.empty?) ? string : new_string
            end
        when 108 # 注释
            new_string = $all_ex_strings[eventCommand.parameters[0]]
            eventCommand.parameters[0] = new_string unless new_string.nil? || new_string.empty?
        when 111 # 如果_分支
            if eventCommand.parameters[0] == 4 && eventCommand.parameters[2] == 1
                new_string = $all_ex_strings[eventCommand.parameters[3]]
                eventCommand.parameters[3] = new_string unless new_string.nil? || new_string.empty?
            elsif eventCommand.parameters[0] == 12
                new_string = $all_ex_strings[eventCommand.parameters[1]]
                eventCommand.parameters[1] = new_string unless new_string.nil? || new_string.empty?
            end
        when 118 # 标签
            new_string = $all_ex_strings[eventCommand.parameters[0]]
            eventCommand.parameters[0] = new_string unless new_string.nil? || new_string.empty?
        when 119 # 转至标签
            new_string = $all_ex_strings[eventCommand.parameters[0]]
            eventCommand.parameters[0] = new_string unless new_string.nil? || new_string.empty?
        when 122 # 变量操作
            if eventCommand.parameters[3] == 4
                new_string = $all_ex_strings[eventCommand.parameters[4]]
                eventCommand.parameters[4] = new_string unless new_string.nil? || new_string.empty?
            end
        when 320 # 更改名字
            new_string = $all_ex_strings[eventCommand.parameters[1]]
            eventCommand.parameters[1] = new_string unless new_string.nil? || new_string.empty?
        when 324 # 更改称号
            new_string = $all_ex_strings[eventCommand.parameters[1]]
            eventCommand.parameters[1] = new_string unless new_string.nil? || new_string.empty?
        when 355 # 脚本
            new_string = $all_ex_strings[eventCommand.parameters[0]]
            eventCommand.parameters[0] = new_string unless new_string.nil? || new_string.empty?
        when 401 # 显示文章的字符串
            new_string = $all_ex_strings[eventCommand.parameters[0]]
            eventCommand.parameters[0] = new_string unless new_string.nil? || new_string.empty?
        when 402 # 如果选择
            new_string = $all_ex_strings[eventCommand.parameters[1]]
            eventCommand.parameters[1] = new_string unless new_string.nil? || new_string.empty?
        when 405 # 显示滚动文字的字符串
            new_string = $all_ex_strings[eventCommand.parameters[0]]
            eventCommand.parameters[0] = new_string unless new_string.nil? || new_string.empty?
        when 408 # 注释的字符串
            new_string = $all_ex_strings[eventCommand.parameters[0]]
            eventCommand.parameters[0] = new_string unless new_string.nil? || new_string.empty?
        when 655 # 脚本的字符串
            new_string = $all_ex_strings[eventCommand.parameters[0]]
            eventCommand.parameters[0] = new_string unless new_string.nil? || new_string.empty?
        end
    end
end

def in_strings_Actors(actors)
    actors[1..-1].each do |actor|
        new_name = $all_ex_strings[actor.name]
        new_nickname = $all_ex_strings[actor.nickname]
        new_note = $all_ex_strings[actor.note]
        actor.name = new_name unless new_name.nil? || new_name.empty?
        actor.nickname = new_nickname unless new_nickname.nil? || new_nickname.empty?
        actor.note = new_note unless new_note.nil? || new_note.empty?
    end
end

def in_strings_Animations(animations)
    animations[1..-1].each do |animation|
        new_name = $all_ex_strings[animation.name]
        animation.name = new_name unless new_name.nil? || new_name.empty?
    end
end

def in_strings_Armors(armors)
    armors[1..-1].each do |armor|
        new_name = $all_ex_strings[armor.name]
        new_description = $all_ex_strings[armor.description]
        new_note = $all_ex_strings[armor.note]
        armor.name = new_name unless new_name.nil? || new_name.empty?
        armor.description = new_description unless new_description.nil? || new_description.empty?
        armor.note = new_note unless new_note.nil? || new_note.empty?
    end
end

def in_strings_Classes(klasses)
    klasses[1..-1].each do |klass|
        new_name = $all_ex_strings[klass.name]
        new_note = $all_ex_strings[klass.note]
        klass.name = new_name unless new_name.nil? || new_name.empty?
        klass.note = new_note unless new_note.nil? || new_note.empty?
    end
end

def in_strings_CommonEvents(commonEvents)
    commonEvents[1..-1].each do |commonEvent|
        new_name = $all_ex_strings[commonEvent.name]
        commonEvent.name = new_name unless new_name.nil? || new_name.empty?
        in_strings_EventCommandList(commonEvent.list)
    end
end

def in_strings_Enemies(enemies)
    enemies[1..-1].each do |enemy|
        new_name = $all_ex_strings[enemy.name]
        new_note = $all_ex_strings[enemy.note]
        enemy.name = new_name unless new_name.nil? || new_name.empty?
        enemy.note = new_note unless new_note.nil? || new_note.empty?
        # if enemy.instance_variable_defined?(:@data_ex) # 判断是否存在@data_ex实例变量
        #     ex_data = enemy.instance_variable_get(:@data_ex)
        #     if ex_data.key?(:lib_name) # 判断是否存在lib_name键
        #         new_lib_name = $all_ex_strings[ex_data[:lib_name]]
        #         ex_data[:lib_name] = new_lib_name unless new_lib_name.nil? || new_lib_name.empty?
        #     end
        #     if ex_data.key?(:lib_category) # 判断是否存在lib_category键
        #         new_lib_category = $all_ex_strings[ex_data[:lib_category]]
        #         ex_data[:lib_category] = new_lib_category unless new_lib_category.nil? || new_lib_category.empty?
        #     end
        # end
    end
end

def in_strings_Items(items)
    items[1..-1].each do |items|
        new_name = $all_ex_strings[items.name]
        new_description = $all_ex_strings[items.description]
        new_note = $all_ex_strings[items.note]
        items.name = new_name unless new_name.nil? || new_name.empty?
        items.description = new_description unless new_description.nil? || new_description.empty?
        items.note = new_note unless new_note.nil? || new_note.empty?
    end
end

def in_strings_Map(map)
    new_display_name = $all_ex_strings[map.display_name]
    map.display_name = new_display_name unless new_display_name.nil? || new_display_name.empty?
    map.events.values.each do |event|
        new_name = $all_ex_strings[event.name]
        event.name = new_name unless new_name.nil? || new_name.empty?
        event.pages.each do |page|
            in_strings_EventCommandList(page.list)
        end
    end
end

def in_strings_MapInfos(mapinfos)
    mapinfos.values.each do |mapinfo|
        new_name = $all_ex_strings[mapinfo.name]
        mapinfo.name = new_name unless new_name.nil? || new_name.empty?
    end
end

def in_strings_Skills(skills)
    skills[1..-1].each do |skill|
        new_name = $all_ex_strings[skill.name]
        new_description = $all_ex_strings[skill.description]
        new_message1 = $all_ex_strings[skill.message1]
        new_message2 = $all_ex_strings[skill.message2]
        new_note = $all_ex_strings[skill.note]
        skill.name = new_name unless new_name.nil? || new_name.empty?
        skill.description = new_description unless new_description.nil? || new_description.empty?
        skill.message1 = new_message1 unless new_message1.nil? || new_message1.empty?
        skill.message2 = new_message2 unless new_message2.nil? || new_message2.empty?
        skill.note = new_note unless new_note.nil? || new_note.empty?
    end
end

def in_strings_States(states)
    states[1..-1].each do |state|
        new_name = $all_ex_strings[state.name]
        new_message1 = $all_ex_strings[state.message1]
        new_message2 = $all_ex_strings[state.message2]
        new_message3 = $all_ex_strings[state.message3]
        new_message4 = $all_ex_strings[state.message4]
        new_note = $all_ex_strings[state.note]
        state.name = new_name unless new_name.nil? || new_name.empty?
        state.message1 = new_message1 unless new_message1.nil? || new_message1.empty?
        state.message2 = new_message2 unless new_message2.nil? || new_message2.empty?
        state.message3 = new_message3 unless new_message3.nil? || new_message3.empty?
        state.message4 = new_message4 unless new_message4.nil? || new_message4.empty?
        state.note = new_note unless new_note.nil? || new_note.empty?
    end
end

def in_strings_System(system)
    system.armor_types[1..-1].map! do |armor_type|
        new_armor_type = $all_ex_strings[armor_type]
        new_armor_type.nil? || new_armor_type.empty? ? armor_type : new_armor_type
    end
    new_currency_unit = $all_ex_strings[system.currency_unit]
    system.currency_unit = new_currency_unit unless new_currency_unit.nil? || new_currency_unit.empty?
    system.elements[1..-1].map! do |element|
        new_element = $all_ex_strings[element]
        new_element.nil? || new_element.empty? ? element : new_element
    end
    new_game_title = $all_ex_strings[system.game_title]
    system.game_title = new_game_title unless new_game_title.nil? || new_game_title.empty?
    system.skill_types[1..-1].map! do |skill_type|
        new_skill_type = $all_ex_strings[skill_type]
        new_skill_type.nil? || new_skill_type.empty? ? skill_type : new_skill_type
    end
    system.switches[1..-1].map! do |switch|
        new_switch = $all_ex_strings[switch]
        new_switch.nil? || new_switch.empty? ? switch : new_switch
    end
    system.terms.basic.map! do |basic|
        new_basic = $all_ex_strings[basic]
        new_basic.nil? || new_basic.empty? ? basic : new_basic
    end
    system.terms.commands.map! do |command|
        new_command = $all_ex_strings[command]
        new_command.nil? || new_command.empty? ? command : new_command
    end
    system.terms.etypes.map! do |etype|
        new_etype = $all_ex_strings[etype]
        new_etype.nil? || new_etype.empty? ? etype : new_etype
    end
    system.terms.params.map! do |param|
        new_param = $all_ex_strings[param]
        new_param.nil? || new_param.empty? ? param : new_param
    end
    system.variables[1..-1].map! do |variable|
        new_variable = $all_ex_strings[variable]
        new_variable.nil? || new_variable.empty? ? variable : new_variable
    end
    system.weapon_types[1..-1].map! do |weapon_type|
        new_weapon_type = $all_ex_strings[weapon_type]
        new_weapon_type.nil? || new_weapon_type.empty? ? weapon_type : new_weapon_type
    end
end

def in_strings_Tilesets(tilesets)
    tilesets[1..-1].each do |tileset|
        new_name = $all_ex_strings[tileset.name]
        new_note = $all_ex_strings[tileset.note]
        tileset.name = new_name unless new_name.nil? || new_name.empty?
        tileset.note = new_note unless new_note.nil? || new_note.empty?
    end
end

def in_strings_Troops(troops)
    troops[1..-1].each do |troop|
        new_name = $all_ex_strings[troop.name]
        troop.name = new_name unless new_name.nil? || new_name.empty?
    end
end

def in_strings_Weapons(weapons)
    weapons[1..-1].each do |weapon|
        new_name = $all_ex_strings[weapon.name]
        new_description = $all_ex_strings[weapon.description]
        new_note = $all_ex_strings[weapon.note]
        weapon.name = new_name unless new_name.nil? || new_name.empty?
        weapon.description = new_description unless new_description.nil? || new_description.empty?
        weapon.note = new_note unless new_note.nil? || new_note.empty?
    end
end

FileUtils.mkdir_p('Data_New') unless Dir.exist?('Data_New')
# 全局哈希表，存储所有的字符串映射
$all_ex_strings = Oj.load(File.read('ManualTransFile.json'))

[
    'Data/Actors.rvdata2',
    'Data/Animations.rvdata2',
    'Data/Armors.rvdata2',
    'Data/Classes.rvdata2',
    'Data/CommonEvents.rvdata2',
    'Data/Enemies.rvdata2',
    'Data/Items.rvdata2',
    *Dir.glob('Data/Map[0-9][0-9][0-9].rvdata2'),
    'Data/Map006.rvdata2',
    'Data/MapInfos.rvdata2',
    'Data/Skills.rvdata2',
    'Data/States.rvdata2',
    'Data/System.rvdata2',
    'Data/Tilesets.rvdata2',
    'Data/Troops.rvdata2',
    'Data/Weapons.rvdata2'
].each do |rvdata2path|
    print "Injecting strings to \e[32m#{rvdata2path}\e[0m...\n"
    rvdata2basename = File.basename(rvdata2path, '.*')
    File.open(rvdata2path, 'rb') do |rvdata2file|
        object = Marshal.load(rvdata2file.read)
        case rvdata2basename
        when 'Actors'
            in_strings_Actors(object)
        when 'Animations'
            in_strings_Animations(object)
        when 'Armors'
            in_strings_Armors(object)
        when 'Classes'
            in_strings_Classes(object)
        when 'CommonEvents'
            in_strings_CommonEvents(object)
        when 'Enemies'
            in_strings_Enemies(object)
        when 'Items'
            in_strings_Items(object)
        when /\AMap\d+\z/
            in_strings_Map(object)
        when 'MapInfos'
            in_strings_MapInfos(object)
        when 'Skills'
            in_strings_Skills(object)
        when 'States'
            in_strings_States(object)
        when 'System'
            in_strings_System(object)
        when 'Tilesets'
            in_strings_Tilesets(object)
        when 'Troops'
            in_strings_Troops(object)
        when 'Weapons'
            in_strings_Weapons(object)
        end

        # 将替换后的object序列化到新的rvdata2文件中
        File.open('Data_New/' + rvdata2basename + '.rvdata2', 'wb') do |rvdata2file|
            rvdata2file.write(Marshal.dump(object))
        end
    end
end
