#!/usr/bin/env ruby
require 'oj'
require 'zlib'
require 'fileutils'
require_relative 'RGSS3'

def to_rvdata2_EventCommandList(list_object, list_array)
    list_array.each do |eventCommand|
        index = eventCommand[:id]
        case eventCommand[:code]
        when 102 # 显示选项
            list_object[index].parameters[0] = eventCommand[:parameters]
        when 108 # 注释
            list_object[index].parameters[0] = eventCommand[:parameters]
        when 111 # 如果_分支
            if list_object[index].parameters[0] == 4 && list_object[index].parameters[2] == 1
                list_object[index].parameters[3] = eventCommand[:parameters]
            elsif list_object[index].parameters[0] == 12
                list_object[index].parameters[1] = eventCommand[:parameters]
            end
        when 118 # 标签
            list_object[index].parameters[0] = eventCommand[:parameters]
        when 119 # 转至标签
            list_object[index].parameters[0] = eventCommand[:parameters]
        when 122 # 变量操作
            if list_object[index].parameters[3] == 4
                list_object[index].parameters[4] = eventCommand[:parameters]
            end
        when 320 # 更改名字
            list_object[index].parameters[1] = eventCommand[:parameters]
        when 324 # 更改称号
            list_object[index].parameters[1] = eventCommand[:parameters]
        when 355 # 脚本
            list_object[index].parameters[0] = eventCommand[:parameters]
        when 401 # 显示文章的字符串
            list_object[index].parameters[0] = eventCommand[:parameters]
        when 402 # 如果选择
            list_object[index].parameters[1] = eventCommand[:parameters]
        when 405 # 显示滚动文字的字符串
            list_object[index].parameters[0] = eventCommand[:parameters]
        when 408 # 注释的字符串
            list_object[index].parameters[0] = eventCommand[:parameters]
        when 655 # 脚本的字符串
            list_object[index].parameters[0] = eventCommand[:parameters]
        end
    end
end

def to_rvdata2_Actors(actors)
    File.open("JSON_part/Actors.json", 'r') do |file|
        actors_array = Oj.load(file)
        actors_array.each do |actor|
            index = actor[:id]
            actors[index].name = actor[:name]
            actors[index].nickname = actor[:nickname]
            actors[index].note = actor[:note]
        end
        File.open("Data_New/Actors.rvdata2", 'wb') { |file| Marshal.dump(actors, file) }
    end
end

def to_rvdata2_Animations(animations)
    File.open("JSON_part/Animations.json", 'r') do |file|
        animations_array = Oj.load(file)
        animations_array.each do |animation|
            animations[animation[:id]].name = animation[:name]
        end
        File.open("Data_New/Animations.rvdata2", 'wb') { |file| Marshal.dump(animations, file) }
    end
end

def to_rvdata2_Armors(armors)
    File.open("JSON_part/Armors.json", 'r') do |file|
        armors_array = Oj.load(file)
        armors_array.each do |armor|
            index = armor[:id]
            armors[index].name = armor[:name]
            armors[index].description = armor[:description]
            armors[index].note = armor[:note]
        end
        File.open("Data_New/Armors.rvdata2", 'wb') { |file| Marshal.dump(armors, file) }
    end
end

def to_rvdata2_Classes(klasses)
    File.open("JSON_part/Classes.json", 'r') do |file|
        klasses_array = Oj.load(file)
        klasses_array.each do |klasse|
            index = klasse[:id]
            klasses[index].name = klasse[:name]
            klasses[index].note = klasse[:note]
        end
        File.open("Data_New/Classes.rvdata2", 'wb') { |file| Marshal.dump(klasses, file) }
    end
end

def to_rvdata2_CommonEvents(commonEvents)
    File.open("JSON_part/CommonEvents.json", 'r') do |file|
        commonEvents_array = Oj.load(file)
        commonEvents_array.each do |commonEvent|
            index = commonEvent[:id]
            commonEvents[index].name = commonEvent[:name]
            to_rvdata2_EventCommandList(commonEvents[index].list, commonEvent[:list])
        end
        File.open("Data_New/CommonEvents.rvdata2", 'wb') { |file| Marshal.dump(commonEvents, file) }
    end
end

def to_rvdata2_Enemies(enemies)
    File.open("JSON_part/Enemies.json", 'r') do |file|
        enemies_array = Oj.load(file)
        enemies_array.each do |enemy|
            index = enemy[:id]
            enemies[index].name = enemy[:name]
            enemies[index].note = enemy[:note]
        end
        File.open("Data_New/Enemies.rvdata2", 'wb') { |file| Marshal.dump(enemies, file) }
    end
end

def to_rvdata2_Items(items)
    File.open("JSON_part/Items.json", 'r') do |file|
        items_array = Oj.load(file)
        items_array.each do |item|
            index = item[:id]
            items[index].name = item[:name]
            items[index].description = item[:description]
            items[index].note = item[:note]
        end
        File.open("Data_New/Items.rvdata2", 'wb') { |file| Marshal.dump(items, file) }
    end
end

def to_rvdata2_Map(map, mapname)
    File.open("JSON_part/#{mapname}.json", 'r') do |file|
        map_hash = Oj.load(file)
        map.display_name = map_hash[:display_name]
        map_hash[:events].each do |event|
            event_index = event[:id]
            map.events[event_index].name = event[:name]
            event[:pages].each do |page|
                to_rvdata2_EventCommandList(map.events[event_index].pages[page[:id]].list, page[:list])
            end
        end
        File.open("Data_New/#{mapname}.rvdata2", 'wb') { |file| Marshal.dump(map, file) }
    end
end

def to_rvdata2_MapInfos(mapinfos)
    File.open("JSON_part/MapInfos.json", 'r') do |file|
        mapinfos_array = Oj.load(file)
        mapinfos_array.each do |mapinfo|
            mapinfos[mapinfo[:id]].name = mapinfo[:name]
        end
        File.open("Data_New/MapInfos.rvdata2", 'wb') { |file| Marshal.dump(mapinfos, file) }
    end
end

def to_rvdata2_Scripts(scripts)
    scripts_array = []
    # 读取所有脚本文件, 并且是按照数字顺序排列的，故可以直接<<入数组
    [*Dir.glob("JSON_part/Scripts/[0-9][0-9][0-9].rb")].each do |script|
        File.open(script, 'r') do |file|
            scripts_array << file.read
        end
    end
    scripts_array.each_with_index do |script, index|
        scripts[index][2] = Zlib::Deflate.deflate(script).force_encoding('UTF-8')
    end
    File.open("Data_New/Scripts.rvdata2", 'wb') { |file| Marshal.dump(scripts, file) }
end

def to_rvdata2_Skills(skills)
    File.open("JSON_part/Skills.json", 'r') do |file|
        skills_array = Oj.load(file)
        skills_array.each do |skill|
            index = skill[:id]
            skills[index].name = skill[:name]
            skills[index].description = skill[:description]
            skills[index].message1 = skill[:message1]
            skills[index].message2 = skill[:message2]
            skills[index].note = skill[:note]
        end
        File.open("Data_New/Skills.rvdata2", 'wb') { |file| Marshal.dump(skills, file) }
    end
end

def to_rvdata2_States(states)
    File.open("JSON_part/States.json", 'r') do |file|
        states_array = Oj.load(file)
        states_array.each do |state|
            index = state[:id]
            states[index].name = state[:name]
            states[index].message1 = state[:message1]
            states[index].message2 = state[:message2]
            states[index].message3 = state[:message3]
            states[index].message4 = state[:message4]
            states[index].note = state[:note]
        end
        File.open("Data_New/States.rvdata2", 'wb') { |file| Marshal.dump(states, file) }
    end
end

def to_rvdata2_System(system)
    File.open("JSON_part/System.json", 'r') do |file|
        system_hash = Oj.load(file)
        system.armor_types = system_hash[:armor_types]
        system.currency_unit = system_hash[:currency_unit]
        system.elements = system_hash[:elements]
        system.game_title = system_hash[:game_title]
        system.skill_types = system_hash[:skill_types]
        system.switches = system_hash[:switches]
        system.terms.basic = system_hash[:basic]
        system.terms.commands = system_hash[:commands]
        system.terms.etypes = system_hash[:etypes]
        system.terms.params = system_hash[:params]
        system.variables = system_hash[:variables]
        system.weapon_types = system_hash[:weapon_types]
        File.open("Data_New/System.rvdata2", 'wb') { |file| Marshal.dump(system, file) }
    end
end

def to_rvdata2_Tilesets(tilesets)
    File.open("JSON_part/Tilesets.json", 'r') do |file|
        tilesets_array = Oj.load(file)
        tilesets_array.each do |tileset|
            index = tileset[:id]
            tilesets[index].name = tileset[:name]
            tilesets[index].note = tileset[:note]
        end
        File.open("Data_New/Tilesets.rvdata2", 'wb') { |file| Marshal.dump(tilesets, file) }
    end
end

def to_rvdata2_Troops(troops)
    File.open("JSON_part/Troops.json", 'r') do |file|
        troops_array = Oj.load(file)
        troops_array.each do |troop|
            index = troop[:id]
            troops[index].name = troop[:name]
        end
        File.open("Data_New/Troops.rvdata2", 'wb') { |file| Marshal.dump(troops, file) }
    end
end

def to_rvdata2_Weapons(weapons)
    File.open("JSON_part/Weapons.json", 'r') do |file|
        weapons_array = Oj.load(file)
        weapons_array.each do |weapon|
            index = weapon[:id]
            weapons[index].name = weapon[:name]
            weapons[index].description = weapon[:description]
            weapons[index].note = weapon[:note]
        end
        File.open("Data_New/Weapons.rvdata2", 'wb') { |file| Marshal.dump(weapons, file) }
    end
end

FileUtils.mkdir_p('Data_New') unless Dir.exist?('Data_New')
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
    'Data/Scripts.rvdata2',
    'Data/Skills.rvdata2',
    'Data/States.rvdata2',
    'Data/System.rvdata2',
    'Data/Tilesets.rvdata2',
    'Data/Troops.rvdata2',
    'Data/Weapons.rvdata2'
].each do |rvdata2path|
    rvdata2basename = File.basename(rvdata2path, '.*')
    print "\e[33mReading \e[37m#{rvdata2path}\e[0m...\r"
    File.open(rvdata2path, 'r') do |rvdata2file|
        print "\e[2K\e[34mUnserializing \e[37m#{rvdata2path}\e[0m...\r"
        object = Marshal.load(rvdata2file)
        case rvdata2basename
        when 'Actors'
            to_rvdata2_Actors(object)
        when 'Animations'
            to_rvdata2_Animations(object)
        when 'Armors'
            to_rvdata2_Armors(object)
        when 'Classes'
            to_rvdata2_Classes(object)
        when 'CommonEvents'
            to_rvdata2_CommonEvents(object)
        when 'Enemies'
            to_rvdata2_Enemies(object)
        when 'Items'
            to_rvdata2_Items(object)
        when /\AMap\d+\z/
            to_rvdata2_Map(object, rvdata2basename)
        when 'MapInfos'
            to_rvdata2_MapInfos(object)
        when 'Scripts'
            to_rvdata2_Scripts(object)
        when 'Skills'
            to_rvdata2_Skills(object)
        when 'States'
            to_rvdata2_States(object)
        when 'System'
            to_rvdata2_System(object)
        when 'Tilesets'
            to_rvdata2_Tilesets(object)
        when 'Troops'
            to_rvdata2_Troops(object)
        when 'Weapons'
            to_rvdata2_Weapons(object)
        end
    end
    print "\e[2K\e[32mUnserialized \e[37m#{rvdata2path}\e[0m.\n"
end
