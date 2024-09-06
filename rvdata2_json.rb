require 'oj'
require 'fileutils'
require_relative 'RGSS3'

def to_json_EventCommandList(eventcommandlist)
    eventcommandlist_json = []
    eventcommandlist.each_with_index do |eventcommand, index|
        case eventcommand.code
        when 102 # 显示选项
            eventcommandlist_json << { id: index, code: EVENT_COMMANDS[102], parameters: eventcommand.parameters[0] }
        when 108 # 注释
            eventcommandlist_json << { id: index, code: EVENT_COMMANDS[108], parameters: eventcommand.parameters[0] }
        when 111 # 如果_分支
            if eventcommand.parameters[0] == 4 && eventcommand.parameters[2] == 1
                eventcommandlist_json << { id: index, code: EVENT_COMMANDS[111], parameters: eventcommand.parameters[3] }
            elsif eventcommand.parameters[0] == 12
                eventcommandlist_json << { id: index, code: EVENT_COMMANDS[111], parameters: eventcommand.parameters[1] }
            end
        when 118 # 标签
            eventcommandlist_json << { id: index, code: EVENT_COMMANDS[118], parameters: eventcommand.parameters[0] }
        when 119 # 转至标签
            eventcommandlist_json << { id: index, code: EVENT_COMMANDS[119], parameters: eventcommand.parameters[0] }
        when 122 # 变量操作
            if eventcommand.parameters[3] == 4
                eventcommandlist_json << { id: index, code: EVENT_COMMANDS[122], parameters: eventcommand.parameters[4] }
            end
        when 320 # 更改名字
            eventcommandlist_json << { id: index, code: EVENT_COMMANDS[320], parameters: eventcommand.parameters[1] }
        when 324 # 更改称号
            eventcommandlist_json << { id: index, code: EVENT_COMMANDS[324], parameters: eventcommand.parameters[1] }
        when 355 # 脚本
            eventcommandlist_json << { id: index, code: EVENT_COMMANDS[355], parameters: eventcommand.parameters[0] }
        when 401 # 显示文章的字符串
            eventcommandlist_json << { id: index, code: EVENT_COMMANDS[401], parameters: eventcommand.parameters[0] }
        when 402 # 如果选择
            eventcommandlist_json << { id: index, code: EVENT_COMMANDS[402], parameters: eventcommand.parameters[1] }
        when 405 # 显示滚动文字的字符串
            eventcommandlist_json << { id: index, code: EVENT_COMMANDS[405], parameters: eventcommand.parameters[0] }
        when 408 # 注释的字符串
            eventcommandlist_json << { id: index, code: EVENT_COMMANDS[408], parameters: eventcommand.parameters[0] }
        when 655 # 脚本的字符串
            eventcommandlist_json << { id: index, code: EVENT_COMMANDS[655], parameters: eventcommand.parameters[0] }
        end
    end
    return eventcommandlist_json
end

def to_json_Actors(actors)
    actors_josn = []
    actors[1..-1].each do |actor|
        actors_josn << { id: actor.id, name: actor.name, nickname: actor.nickname }
    end
    File.open("JSON/Actors.json", 'w') { |file| file.write(Oj.dump(actors_josn, :indent => 4)) }
end

def to_json_Animations(animations)
    animations_josn = []
    animations[1..-1].each do |animation|
        animations_josn << { id: animation.id, name: animation.name }
    end
    File.open("JSON/Animations.json", 'w') { |file| file.write(Oj.dump(animations_josn, :indent => 4)) }
end

def to_json_Armors(armors)
    armors_josn = []
    armors[1..-1].each do |armor|
        armors_josn << { id: armor.id, name: armor.name, description: armor.description }
    end
    File.open("JSON/Armors.json", 'w') { |file| file.write(Oj.dump(armors_josn, :indent => 4)) }
end

def to_json_Classes(klasses)
    klasses_josn = []
    klasses[1..-1].each do |klasse|
        klasses_josn << { id: klasse.id, name: klasse.name }
    end
    File.open("JSON/Classes.json", 'w') { |file| file.write(Oj.dump(klasses_josn, :indent => 4)) }
end

def to_json_CommonEvents(commonEvents)
    commonEvents_josn = []
    commonEvents[1..-1].each do |commonevent|
        commonEvents_josn << { id: commonevent.id, name: commonevent.name, list: to_json_EventCommandList(commonevent.list) }
    end
    File.open("JSON/CommonEvents.json", 'w') { |file| file.write(Oj.dump(commonEvents_josn, :indent => 4)) }
end

def to_json_Enemies(enemies)
    enemies_josn = []
    enemies[1..-1].each do |enemy|
        enemies_josn << { id: enemy.id, name: enemy.name }
    end
    File.open("JSON/Enemies.json", 'w') { |file| file.write(Oj.dump(enemies_josn, :indent => 4)) }
end

def to_json_Items(items)
    items_josn = []
    items[1..-1].each do |item|
        items_josn << { id: item.id, name: item.name, description: item.description }
    end
    File.open("JSON/Items.json", 'w') { |file| file.write(Oj.dump(items_josn, :indent => 4)) }
end

def to_json_Map(map, mapname)
    map_json = {}
    map_json[:display_name] = map.display_name
    map_json[:events] = []
    map.events.values.each do |event|
        event_hash = {}
        event_hash[:id] = event.id
        event_hash[:name] = event.name
        event_hash[:pages] = []
        event.pages.each_with_index do |page, index|
            event_hash[:pages] << { id: index, list: to_json_EventCommandList(page.list) }
        end
        map_json[:events] << event_hash
    end
    File.open("JSON/#{mapname}.json", 'w') { |file| file.write(Oj.dump(map_json, :indent => 4)) }
end

def to_json_MapInfos(mapinfos)
    mapinfos_json = []
    mapinfos.each do |key, value|
        mapinfos_json << { id: key, name: value.name }
    end
    File.open("JSON/MapInfos.json", 'w') { |file| file.write(Oj.dump(mapinfos_json, :indent => 4)) }
end

def to_json_Skills(skills)
    skills_josn = []
    skills[1..-1].each do |skill|
        skills_josn << { id: skill.id, name: skill.name, description: skill.description, message1: skill.message1, message2: skill.message2 }
    end
    File.open("JSON/Skills.json", 'w') { |file| file.write(Oj.dump(skills_josn, :indent => 4)) }
end

def to_json_States(states)
    states_josn = []
    states[1..-1].each do |state|
        states_josn << { id: state.id, name: state.name, message1: state.message1, message2: state.message2, message3: state.message3, message4: state.message4 }
    end
    File.open("JSON/States.json", 'w') { |file| file.write(Oj.dump(states_josn, :indent => 4)) }
end

def to_json_System(system)
    system_json = {}
    system_json[:armor_types] = system.armor_types
    system_json[:currency_unit] = system.currency_unit
    system_json[:elements] = system.elements
    system_json[:game_title] = system.game_title
    system_json[:skill_types] = system.skill_types
    system_json[:switches] = system.switches
    system_json[:basic] = system.terms.basic
    system_json[:commands] = system.terms.commands
    system_json[:etypes] = system.terms.etypes
    system_json[:params] = system.terms.params
    system_json[:variables] = system.variables
    system_json[:weapon_types] = system.weapon_types
    File.open("JSON/System.json", 'w') { |file| file.write(Oj.dump(system_json, :indent => 4)) }
end

def to_json_Tilesets(tilesets)
    tilesets_josn = []
    tilesets[1..-1].each do |tileset|
        tilesets_josn << { id: tileset.id, name: tileset.name }
    end
    File.open("JSON/Tilesets.json", 'w') { |file| file.write(Oj.dump(tilesets_josn, :indent => 4)) }
end

def to_json_Troops(troops)
    troops_josn = []
    troops[1..-1].each do |troop|
        troops_josn << { id: troop.id, name: troop.name }
    end
    File.open("JSON/Troops.json", 'w') { |file| file.write(Oj.dump(troops_josn, :indent => 4)) }
end

def to_json_Weapons(weapons)
    weapons_josn = []
    weapons[1..-1].each do |weapon|
        weapons_josn << { id: weapon.id, name: weapon.name, description: weapon.description }
    end
    File.open("JSON/Weapons.json", 'w') { |file| file.write(Oj.dump(weapons_josn, :indent => 4)) }
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
    'Data/Skills.rvdata2',
    'Data/States.rvdata2',
    'Data/System.rvdata2',
    'Data/Tilesets.rvdata2',
    'Data/Troops.rvdata2',
    'Data/Weapons.rvdata2'
].each do |rvdata2path|
    puts rvdata2path
    rvdatafilebasename = File.basename(rvdata2path, '.*')
    File.open(rvdata2path, 'rb') do |rvdata2file|
        object = Marshal.load(rvdata2file.read)
        case rvdatafilebasename
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
            to_json_Map(object, rvdatafilebasename)
        when 'MapInfos'
            to_json_MapInfos(object)
        when 'Scripts'
            self.decompile_scripts
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
end