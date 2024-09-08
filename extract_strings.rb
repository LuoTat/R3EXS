require 'oj'
require_relative 'RGSS3'

def ex_strings_EventCommandList(eventCommandList)
    strings = []
    eventCommandList.each do |eventCommand|
        case eventCommand.code
        when 102 # 显示选项
            strings.concat(eventCommand.parameters[0])
        when 108 # 注释
            strings << eventCommand.parameters[0]
        when 111 # 如果_分支
            if eventCommand.parameters[0] == 4 && eventCommand.parameters[2] == 1
                strings << eventCommand.parameters[3]
            elsif eventCommand.parameters[0] == 12
                strings << eventCommand.parameters[1]
            end
        when 118 # 标签
            strings << eventCommand.parameters[0]
        when 119 # 转至标签
            strings << eventCommand.parameters[0]
        when 122 # 变量操作
            if eventCommand.parameters[3] == 4
                strings << eventCommand.parameters[4]
            end
        when 320 # 更改名字
            strings << eventCommand.parameters[1]
        when 324 # 更改称号
            strings << eventCommand.parameters[1]
        when 355 # 脚本
            strings << eventCommand.parameters[0]
        when 401 # 显示文章的字符串
            strings << eventCommand.parameters[0]
        when 402 # 如果选择
            strings << eventCommand.parameters[1]
        when 405 # 显示滚动文字的字符串
            strings << eventCommand.parameters[0]
        when 408 # 注释的字符串
            strings << eventCommand.parameters[0]
        when 655 # 脚本的字符串
            strings << eventCommand.parameters[0]
        end
    end
    return strings
end

def ex_strings_Actors(actors)
    actors[1..-1].each do |actor|
        name = actor.name
        nickname = actor.nickname
        note = actor.note
        $all_ex_strings[name] = name unless name.empty?
        $all_ex_strings[nickname] = nickname unless nickname.empty?
        $all_ex_strings[note] = note unless note.empty?
    end
end

def ex_strings_Animations(animations)
    animations[1..-1].each_with_index do |animation|
        name = animation.name
        $all_ex_strings[name] = name unless name.empty?
    end
end

def ex_strings_Armors(armors)
    armors[1..-1].each do |armor|
        name = armor.name
        description = armor.description
        note = armor.note
        $all_ex_strings[name] = name unless name.empty?
        $all_ex_strings[description] = description unless description.empty?
        $all_ex_strings[note] = note unless note.empty?
    end
end

def ex_strings_Classes(klasses)
    klasses[1..-1].each do |klass|
        name = klass.name
        note = klass.note
        $all_ex_strings[name] = name unless name.empty?
        $all_ex_strings[note] = note unless note.empty?
    end
end

def ex_strings_CommonEvents(commonEvents)
    commonEvents[1..-1].each do |commonEvent|
        name = commonEvent.name
        $all_ex_strings[name] = name unless name.empty?
        ex_strings_EventCommandList(commonEvent.list).each do |string|
            $all_ex_strings[string] = string unless string.empty?
        end
    end
end

def ex_strings_Enemies(enemies)
    enemies[1..-1].each do |enemy|
        name = enemy.name
        note = enemy.note
        $all_ex_strings[name] = name unless name.empty?
        $all_ex_strings[note] = note unless note.empty?
        # if enemy.instance_variable_defined?(:@data_ex) # 判断是否存在@data_ex实例变量
        #     ex_data = enemy.instance_variable_get(:@data_ex)
        #     if ex_data.key?(:lib_name) # 判断是否存在lib_name键
        #         lib_name = ex_data[:lib_name]
        #         $all_ex_strings[lib_name] = lib_name unless lib_name.empty?
        #     end
        #     if ex_data.key?(:lib_category) # 判断是否存在lib_category键
        #         lib_category = ex_data[:lib_category]
        #         $all_ex_strings[lib_category] = lib_category unless lib_category.empty?
        #     end
        # end
    end
end

def ex_strings_Items(items)
    items[1..-1].each do |items|
        name = items.name
        description = items.description
        note = items.note
        $all_ex_strings[name] = name unless name.empty?
        $all_ex_strings[description] = description unless description.empty?
        $all_ex_strings[note] = note unless note.empty?
    end
end

def ex_strings_Map(map)
    display_name = map.display_name
    $all_ex_strings[display_name] = display_name unless display_name.empty?
    map.events.values.each do |event|
        name = event.name
        $all_ex_strings[name] = name unless name.empty?
        event.pages.each do |page|
            ex_strings_EventCommandList(page.list).each do |string|
                $all_ex_strings[string] = string unless string.empty?
            end
        end
    end
end

def ex_strings_MapInfos(mapinfos)
    mapinfos.values.each do |mapinfo|
        name = mapinfo.name
        $all_ex_strings[name] = name unless name.empty?
    end
end

def ex_strings_Skills(skills)
    skills[1..-1].each do |skill|
        name = skill.name
        description = skill.description
        message1 = skill.message1
        message2 = skill.message2
        note = skill.note
        $all_ex_strings[name] = name unless name.empty?
        $all_ex_strings[description] = description unless description.empty?
        $all_ex_strings[message1] = message1 unless message1.empty?
        $all_ex_strings[message2] = message2 unless message2.empty?
        $all_ex_strings[note] = note unless note.empty?
    end
end

def ex_strings_States(states)
    states[1..-1].each do |state|
        name = state.name
        message1 = state.message1
        message2 = state.message2
        message3 = state.message3
        message4 = state.message4
        note = state.note
        $all_ex_strings[name] = name unless name.empty?
        $all_ex_strings[message1] = message1 unless message1.empty?
        $all_ex_strings[message2] = message2 unless message2.empty?
        $all_ex_strings[message3] = message3 unless message3.empty?
        $all_ex_strings[message4] = message4 unless message4.empty?
        $all_ex_strings[note] = note unless note.empty?
    end
end

def ex_strings_System(system)
    system.armor_types[1..-1].each do |armor_type|
        $all_ex_strings[armor_type] = armor_type unless armor_type.empty?
    end
    currency_unit = system.currency_unit
    $all_ex_strings[currency_unit] = currency_unit unless currency_unit.empty?
    system.elements[1..-1].each do |element|
        $all_ex_strings[element] = element unless element.empty?
    end
    game_title = system.game_title
    $all_ex_strings[game_title] = game_title unless game_title.empty?
    system.skill_types[1..-1].each do |skill_type|
        $all_ex_strings[skill_type] = skill_type unless skill_type.empty?
    end
    system.switches[1..-1].each do |switch|
        $all_ex_strings[switch] = switch unless switch.empty?
    end
    system.terms.basic.each do |basic|
        $all_ex_strings[basic] = basic unless basic.empty?
    end
    system.terms.commands.each do |command|
        $all_ex_strings[command] = command unless command.empty?
    end
    system.terms.etypes.each do |etype|
        $all_ex_strings[etype] = etype unless etype.empty?
    end
    system.terms.params.each do |param|
        $all_ex_strings[param] = param unless param.empty?
    end
    system.variables[1..-1].each do |variable|
        $all_ex_strings[variable] = variable unless variable.empty?
    end
    system.weapon_types[1..-1].each do |weapon_type|
        $all_ex_strings[weapon_type] = weapon_type unless weapon_type.empty?
    end
end

def ex_strings_Tilesets(tilesets)
    tilesets[1..-1].each do |tileset|
        name = tileset.name
        note = tileset.note
        $all_ex_strings[name] = name unless name.empty?
        $all_ex_strings[note] = note unless note.empty?
    end
end

def ex_strings_Troops(troops)
    troops[1..-1].each do |troop|
        name = troop.name
        $all_ex_strings[name] = name unless name.empty?
    end
end

def ex_strings_Weapons(weapons)
    weapons[1..-1].each do |weapon|
        name = weapon.name
        description = weapon.description
        note = weapon.note
        $all_ex_strings[name] = name unless name.empty?
        $all_ex_strings[description] = description unless description.empty?
        $all_ex_strings[note] = note unless note.empty?
    end
end

$all_ex_strings = {}
[
    'Data/Actors.rvdata2',
    'Data/Animations.rvdata2',
    'Data/Armors.rvdata2',
    'Data/Classes.rvdata2',
    'Data/CommonEvents.rvdata2',
    'Data/Enemies.rvdata2',
    'Data/Items.rvdata2',
    *Dir.glob('Data/Map[0-9][0-9][0-9].rvdata2'),
    'Data/MapInfos.rvdata2',
    'Data/Skills.rvdata2',
    'Data/States.rvdata2',
    'Data/System.rvdata2',
    'Data/Tilesets.rvdata2',
    'Data/Troops.rvdata2',
    'Data/Weapons.rvdata2'
].each do |rvdata2path|
    print "\e[33mReading \e[37m#{rvdata2path}\e[0m..."
    rvdata2basename = File.basename(rvdata2path, '.*')
    File.open(rvdata2path, 'rb') do |rvdata2file|
        print "\r\e[2K\e[34mExtracting strings from \e[37m#{rvdata2path}\e[0m..."
        object = Marshal.load(rvdata2file.read)
        case rvdata2basename
        when 'Actors'
            ex_strings_Actors(object)
        when 'Animations'
            ex_strings_Animations(object)
        when 'Armors'
            ex_strings_Armors(object)
        when 'Classes'
            ex_strings_Classes(object)
        when 'CommonEvents'
            ex_strings_CommonEvents(object)
        when 'Enemies'
            ex_strings_Enemies(object)
        when 'Items'
            ex_strings_Items(object)
        when /\AMap\d+\z/
            ex_strings_Map(object)
        when 'MapInfos'
            ex_strings_MapInfos(object)
        when 'Scripts'
            self.decompile_scripts
        when 'Skills'
            ex_strings_Skills(object)
        when 'States'
            ex_strings_States(object)
        when 'System'
            ex_strings_System(object)
        when 'Tilesets'
            ex_strings_Tilesets(object)
        when 'Troops'
            ex_strings_Troops(object)
        when 'Weapons'
            ex_strings_Weapons(object)
        end
    end
    print "\r\e[2K\e[32mExtracted strings from \e[37m#{rvdata2path}\e[0m.\n"
end
# 将结果转换为 JSON 格式并输出
all_ex_strings_json = Oj.dump($all_ex_strings, :indent => 4)
File.open('ManualTransFile.json', 'w') { |file| file.write(all_ex_strings_json) }

