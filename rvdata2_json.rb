require 'oj'
require 'zlib'
require 'json'
require 'fileutils'
require_relative 'RGSS3'

def to_array_EventCommandList(eventCommandList)
    eventcommandlist_array = []
    eventCommandList.each_with_index do |eventCommand, index|
        case eventCommand.code
        when 102 # 显示选项
            eventcommandlist_array << { id: index, code: 102, usage: EVENT_COMMANDS[102], parameters: eventCommand.parameters[0] }
        when 108 # 注释
            eventcommandlist_array << { id: index, code: 108, usage: EVENT_COMMANDS[108], parameters: eventCommand.parameters[0] }
        when 111 # 如果_分支
            if eventCommand.parameters[0] == 4 && eventCommand.parameters[2] == 1
                eventcommandlist_array << { id: index, code: 111, usage: EVENT_COMMANDS[111], parameters: eventCommand.parameters[3] }
            elsif eventCommand.parameters[0] == 12
                eventcommandlist_array << { id: index, code: 111, usage: EVENT_COMMANDS[111], parameters: eventCommand.parameters[1] }
            end
        when 118 # 标签
            eventcommandlist_array << { id: index, code: 118, usage: EVENT_COMMANDS[118], parameters: eventCommand.parameters[0] }
        when 119 # 转至标签
            eventcommandlist_array << { id: index, code: 119, usage: EVENT_COMMANDS[119], parameters: eventCommand.parameters[0] }
        when 122 # 变量操作
            if eventCommand.parameters[3] == 4
                eventcommandlist_array << { id: index, code: 122, usage: EVENT_COMMANDS[122], parameters: eventCommand.parameters[4] }
            end
        when 320 # 更改名字
            eventcommandlist_array << { id: index, code: 320, usage: EVENT_COMMANDS[320], parameters: eventCommand.parameters[1] }
        when 324 # 更改称号
            eventcommandlist_array << { id: index, code: 324, usage: EVENT_COMMANDS[324], parameters: eventCommand.parameters[1] }
        when 355 # 脚本
            eventcommandlist_array << { id: index, code: 355, usage: EVENT_COMMANDS[355], parameters: eventCommand.parameters[0] }
        when 401 # 显示文章的字符串
            eventcommandlist_array << { id: index, code: 401, usage: EVENT_COMMANDS[401], parameters: eventCommand.parameters[0] }
        when 402 # 如果选择
            eventcommandlist_array << { id: index, code: 402, usage: EVENT_COMMANDS[402], parameters: eventCommand.parameters[1] }
        when 405 # 显示滚动文字的字符串
            eventcommandlist_array << { id: index, code: 405, usage: EVENT_COMMANDS[405], parameters: eventCommand.parameters[0] }
        when 408 # 注释的字符串
            eventcommandlist_array << { id: index, code: 408, usage: EVENT_COMMANDS[408], parameters: eventCommand.parameters[0] }
        when 655 # 脚本的字符串
            eventcommandlist_array << { id: index, code: 655, usage: EVENT_COMMANDS[655], parameters: eventCommand.parameters[0] }
        end
    end
    return eventcommandlist_array
end

def to_json_Actors(actors)
    actors_array = []
    actors[1..-1].each do |actor|
        actors_array << { id: actor.id, name: actor.name, nickname: actor.nickname, note: actor.note }
    end
    File.open("JSON/Actors.json", 'w') { |file| file.write(Oj.dump(actors_array, :indent => 4)) }
end

def to_json_Animations(animations)
    animations_array = []
    animations[1..-1].each do |animation|
        animations_array << { id: animation.id, name: animation.name }
    end
    File.open("JSON/Animations.json", 'w') { |file| file.write(Oj.dump(animations_array, :indent => 4)) }
end

def to_json_Armors(armors)
    armors_array = []
    armors[1..-1].each do |armor|
        armors_array << { id: armor.id, name: armor.name, description: armor.description, note: armor.note }
    end
    File.open("JSON/Armors.json", 'w') { |file| file.write(Oj.dump(armors_array, :indent => 4)) }
end

def to_json_Classes(klasses)
    klasses_array = []
    klasses[1..-1].each do |klasse|
        klasses_array << { id: klasse.id, name: klasse.name, note: klasse.note }
    end
    File.open("JSON/Classes.json", 'w') { |file| file.write(Oj.dump(klasses_array, :indent => 4)) }
end

def to_json_CommonEvents(commonEvents)
    commonEvents_array = []
    commonEvents[1..-1].each do |commonEvent|
        commonEvents_array << { id: commonEvent.id, name: commonEvent.name, list: to_array_EventCommandList(commonEvent.list) }
    end
    File.open("JSON/CommonEvents.json", 'w') { |file| file.write(Oj.dump(commonEvents_array, :indent => 4)) }
end

def to_json_Enemies(enemies)
    enemies_array = []
    enemies[1..-1].each do |enemy|
        enemies_array << { id: enemy.id, name: enemy.name, note: enemy.note }
    end
    File.open("JSON/Enemies.json", 'w') { |file| file.write(Oj.dump(enemies_array, :indent => 4)) }
end

def to_json_Items(items)
    items_array = []
    items[1..-1].each do |item|
        items_array << { id: item.id, name: item.name, description: item.description, note: item.note }
    end
    File.open("JSON/Items.json", 'w') { |file| file.write(Oj.dump(items_array, :indent => 4)) }
end

def to_json_Map(map, mapname)
    map_hash = {}
    map_hash[:display_name] = map.display_name
    map_hash[:events] = []
    map.events.values.each do |event|
        event_hash = {}
        event_hash[:id] = event.id
        event_hash[:name] = event.name
        event_hash[:pages] = []
        event.pages.each_with_index do |page, index|
            event_hash[:pages] << { id: index, list: to_array_EventCommandList(page.list) }
        end
        map_hash[:events] << event_hash
    end
    File.open("JSON/#{mapname}.json", 'w') { |file| file.write(Oj.dump(map_hash, :indent => 4)) }
end

def to_json_MapInfos(mapinfos)
    mapinfos_array = []
    mapinfos.each do |key, value|
        mapinfos_array << { id: key, name: value.name }
    end
    File.open("JSON/MapInfos.json", 'w') { |file| file.write(Oj.dump(mapinfos_array, :indent => 4)) }
end

def to_json_Scripts(scripts)
    FileUtils.mkdir_p('JSON/Scripts') unless Dir.exist?('JSON/Scripts')
    scripts_info = {}
    scripts.each_with_index do |script, index|
        scripts_info[index] = script[1]
        File.open("JSON/Scripts/#{sprintf('%03d', index)}.rb", 'w') { |file| file.write(Zlib::Inflate.inflate(script[2]).force_encoding('UTF-8')) }
    end
    File.open("JSON/Scripts/Scripts_info.json", 'w') { |file| file.write(Oj.dump(scripts_info, :indent => 4)) }
end

def to_json_Skills(skills)
    skills_array = []
    skills[1..-1].each do |skill|
        skills_array << { id: skill.id, name: skill.name, description: skill.description, message1: skill.message1, message2: skill.message2, note: skill.note }
    end
    File.open("JSON/Skills.json", 'w') { |file| file.write(Oj.dump(skills_array, :indent => 4)) }
end

def to_json_States(states)
    states_array = []
    states[1..-1].each do |state|
        states_array << { id: state.id, name: state.name, message1: state.message1, message2: state.message2, message3: state.message3, message4: state.message4, note: state.note }
    end
    File.open("JSON/States.json", 'w') { |file| file.write(Oj.dump(states_array, :indent => 4)) }
end

def to_json_System(system)
    system_hash = {}
    system_hash[:armor_types] = system.armor_types
    system_hash[:currency_unit] = system.currency_unit
    system_hash[:elements] = system.elements
    system_hash[:game_title] = system.game_title
    system_hash[:skill_types] = system.skill_types
    system_hash[:switches] = system.switches
    system_hash[:basic] = system.terms.basic
    system_hash[:commands] = system.terms.commands
    system_hash[:etypes] = system.terms.etypes
    system_hash[:params] = system.terms.params
    system_hash[:variables] = system.variables
    system_hash[:weapon_types] = system.weapon_types
    File.open("JSON/System.json", 'w') { |file| file.write(Oj.dump(system_hash, :indent => 4)) }
end

def to_json_Tilesets(tilesets)
    tilesets_array = []
    tilesets[1..-1].each do |tileset|
        tilesets_array << { id: tileset.id, name: tileset.name, note: tileset.note }
    end
    File.open("JSON/Tilesets.json", 'w') { |file| file.write(Oj.dump(tilesets_array, :indent => 4)) }
end

def to_json_Troops(troops)
    troops_array = []
    troops[1..-1].each do |troop|
        troops_array << { id: troop.id, name: troop.name }
    end
    File.open("JSON/Troops.json", 'w') { |file| file.write(Oj.dump(troops_array, :indent => 4)) }
end

def to_json_Weapons(weapons)
    weapons_array = []
    weapons[1..-1].each do |weapon|
        weapons_array << { id: weapon.id, name: weapon.name, description: weapon.description, note: weapon.note }
    end
    File.open("JSON/Weapons.json", 'w') { |file| file.write(Oj.dump(weapons_array, :indent => 4)) }
end

FileUtils.mkdir_p('JSON') unless Dir.exist?('JSON')
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
    File.open(rvdata2path, 'rb') do |rvdata2file|
        print "\e[2K\e[34mSerializing \e[37m#{rvdata2path}\e[0m...\r"
        object = Marshal.load(rvdata2file.read)
        case rvdata2basename
        when 'Actors'
            to_json_Actors(object)
        when 'Animations'
            to_json_Animations(object)
        when 'Armors'
            to_json_Armors(object)
        when 'Classes'
            to_json_Classes(object)
        when 'CommonEvents'
            to_json_CommonEvents(object)
        when 'Enemies'
            to_json_Enemies(object)
        when 'Items'
            to_json_Items(object)
        when /\AMap\d+\z/
            to_json_Map(object, rvdata2basename)
        when 'MapInfos'
            to_json_MapInfos(object)
        when 'Scripts'
            to_json_Scripts(object)
        when 'Skills'
            to_json_Skills(object)
        when 'States'
            to_json_States(object)
        when 'System'
            to_json_System(object)
        when 'Tilesets'
            to_json_Tilesets(object)
        when 'Troops'
            to_json_Troops(object)
        when 'Weapons'
            to_json_Weapons(object)
        end
    end
    print "\e[2K\e[32mSerialized \e[37m#{rvdata2path}\e[0m.\n"
end