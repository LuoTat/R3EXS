require 'oj'
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
    File.open("Data/Actors.rvdata2", 'rb') do |file|
        object = Marshal.load(file.read)
        actors.each do |actor|
            index = actor[:id]
            object[index].name = actor[:name]
            object[index].nickname = actor[:nickname]
            object[index].note = actor[:note]
        end
        File.open("Data_New/Actors.rvdata2", 'wb') { |file| file.write(Marshal.dump(object)) }
    end
end

def to_rvdata2_Animations(animations)
    File.open("Data/Animations.rvdata2", 'rb') do |file|
        object = Marshal.load(file.read)
        animations.each do |animation|
            object[animation[:id]].name = animation[:name]
        end
        File.open("Data_New/Animations.rvdata2", 'wb') { |file| file.write(Marshal.dump(object)) }
    end
end

def to_rvdata2_Armors(armors)
    File.open("Data/Armors.rvdata2", 'rb') do |file|
        object = Marshal.load(file.read)
        armors.each do |armor|
            index = armor[:id]
            object[index].name = armor[:name]
            object[index].description = armor[:description]
            object[index].note = armor[:note]
        end
        File.open("Data_New/Armors.rvdata2", 'wb') { |file| file.write(Marshal.dump(object)) }
    end
end

def to_rvdata2_Classes(klasses)
    File.open("Data/Classes.rvdata2", 'rb') do |file|
        object = Marshal.load(file.read)
        klasses.each do |klasse|
            index = klasse[:id]
            object[index].name = klasse[:name]
            object[index].note = klasse[:note]
        end
        File.open("Data_New/Classes.rvdata2", 'wb') { |file| file.write(Marshal.dump(object)) }
    end
end

def to_rvdata2_CommonEvents(commonEvents)
    File.open("Data/CommonEvents.rvdata2", 'rb') do |file|
        object = Marshal.load(file.read)
        commonEvents.each do |commonEvent|
            index = commonEvent[:id]
            object[index].name = commonEvent[:name]
            to_rvdata2_EventCommandList(object[index].list, commonEvent[:list])
        end
        File.open("Data_New/CommonEvents.rvdata2", 'wb') { |file| file.write(Marshal.dump(object)) }
    end
end

def to_rvdata2_Enemies(enemies)
    File.open("Data/Enemies.rvdata2", 'rb') do |file|
        object = Marshal.load(file.read)
        enemies.each do |enemy|
            index = enemy[:id]
            object[index].name = enemy[:name]
            object[index].note = enemy[:note]
        end
        File.open("Data_New/Enemies.rvdata2", 'wb') { |file| file.write(Marshal.dump(object)) }
    end
end

def to_rvdata2_Items(items)
    File.open("Data/Items.rvdata2", 'rb') do |file|
        object = Marshal.load(file.read)
        items.each do |item|
            index = item[:id]
            object[index].name = item[:name]
            object[index].description = item[:description]
            object[index].note = item[:note]
        end
        File.open("Data_New/Items.rvdata2", 'wb') { |file| file.write(Marshal.dump(object)) }
    end
end

def to_rvdata2_Map(map, mapname)
    File.open("Data/#{mapname}.rvdata2", 'rb') do |file|
        object = Marshal.load(file.read)
        object.display_name = map[:display_name]
        map[:events].each do |event|
            event_index = event[:id]
            object.events[event_index].name = event[:name]
            event[:pages].each do |page|
                to_rvdata2_EventCommandList(object.events[event_index].pages[page[:id]].list, page[:list])
            end
        end
        File.open("Data_New/#{mapname}.rvdata2", 'wb') { |file| file.write(Marshal.dump(object)) }
    end
end

def to_rvdata2_MapInfos(mapinfos)
    File.open("Data/MapInfos.rvdata2", 'rb') do |file|
        object = Marshal.load(file.read)
        mapinfos.each do |mapinfo|
            object[mapinfo[:id]].name = mapinfo[:name]
        end
        File.open("Data_New/MapInfos.rvdata2", 'wb') { |file| file.write(Marshal.dump(object)) }
    end
end

def to_rvdata2_Skills(skills)
    File.open("Data/Skills.rvdata2", 'rb') do |file|
        object = Marshal.load(file.read)
        skills.each do |skill|
            index = skill[:id]
            object[index].name = skill[:name]
            object[index].description = skill[:description]
            object[index].message1 = skill[:message1]
            object[index].message2 = skill[:message2]
            object[index].note = skill[:note]
        end
        File.open("Data_New/Skills.rvdata2", 'wb') { |file| file.write(Marshal.dump(object)) }
    end
end

def to_rvdata2_States(states)
    File.open("Data/States.rvdata2", 'rb') do |file|
        object = Marshal.load(file.read)
        states.each do |state|
            index = state[:id]
            object[index].name = state[:name]
            object[index].message1 = state[:message1]
            object[index].message2 = state[:message2]
            object[index].message3 = state[:message3]
            object[index].message4 = state[:message4]
            object[index].note = state[:note]
        end
        File.open("Data_New/States.rvdata2", 'wb') { |file| file.write(Marshal.dump(object)) }
    end
end

def to_rvdata2_System(system)
    File.open("Data/System.rvdata2", 'rb') do |file|
        object = Marshal.load(file.read)
        object.armor_types = system[:armor_types]
        object.currency_unit = system[:currency_unit]
        object.elements = system[:elements]
        object.game_title = system[:game_title]
        object.skill_types = system[:skill_types]
        object.switches = system[:switches]
        object.terms.basic = system[:basic]
        object.terms.commands = system[:commands]
        object.terms.etypes = system[:etypes]
        object.terms.params = system[:params]
        object.variables = system[:variables]
        object.weapon_types = system[:weapon_types]
        File.open("Data_New/System.rvdata2", 'wb') { |file| file.write(Marshal.dump(object)) }
    end
end

def to_rvdata2_Tilesets(tilesets)
    File.open("Data/Tilesets.rvdata2", 'rb') do |file|
        object = Marshal.load(file.read)
        tilesets.each do |tileset|
            index = tileset[:id]
            object[index].name = tileset[:name]
            object[index].note = tileset[:note]
        end
        File.open("Data_New/Tilesets.rvdata2", 'wb') { |file| file.write(Marshal.dump(object)) }
    end
end

def to_rvdata2_Troops(troops)
    File.open("Data/Troops.rvdata2", 'rb') do |file|
        object = Marshal.load(file.read)
        troops.each do |troop|
            index = troop[:id]
            object[index].name = troop[:name]
        end
        File.open("Data_New/Troops.rvdata2", 'wb') { |file| file.write(Marshal.dump(object)) }
    end
end

def to_rvdata2_Weapons(weapons)
    File.open("Data/Weapons.rvdata2", 'rb') do |file|
        object = Marshal.load(file.read)
        weapons.each do |weapon|
            index = weapon[:id]
            object[index].name = weapon[:name]
            object[index].description = weapon[:description]
            object[index].note = weapon[:note]
        end
        File.open("Data_New/Weapons.rvdata2", 'wb') { |file| file.write(Marshal.dump(object)) }
    end
end

FileUtils.mkdir_p('Data_New') unless Dir.exist?('Data_New')
[
    'JSON/Actors.json',
    'JSON/Animations.json',
    'JSON/Armors.json',
    'JSON/Classes.json',
    'JSON/CommonEvents.json',
    'JSON/Enemies.json',
    'JSON/Items.json',
    *Dir.glob('JSON/Map[0-9][0-9][0-9].json'),
    'JSON/MapInfos.json',
    'JSON/Skills.json',
    'JSON/States.json',
    'JSON/System.json',
    'JSON/Tilesets.json',
    'JSON/Troops.json',
    'JSON/Weapons.json'
].each do |jsonpath|
    jsonbasename = File.basename(jsonpath, '.*')
    print "\e[33m#{jsonpath}\e[0m -> \e[32mData_New/#{jsonbasename}.rvdata2\e[0m\n"
    File.open(jsonpath, 'r') do |jsonfile|
        object = Oj.load(jsonfile.read)
        case jsonbasename
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
            to_rvdata2_Map(object, jsonbasename)
        when 'MapInfos'
            to_rvdata2_MapInfos(object)
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
end