require 'oj'
require 'fileutils'
require_relative 'RGSS3'

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
    # 'JSON/Scripts.json',
    'JSON/Skills.json',
    'JSON/States.json',
    'JSON/System.json',
    'JSON/Tilesets.json',
    'JSON/Troops.json',
    'JSON/Weapons.json'
].each do |jsonpath|
    puts jsonpath
    File.open(jsonpath, 'r') do |jsonfile|
        # 从 JSON 字符串反序列化对象
        object = Oj.load(jsonfile.read)
        # 将对象序列化为二进制文件
        rvdata2 = Marshal.dump(object)
        File.open('Data_New/' + File.basename(jsonpath, '.*') + '.rvdata2', 'wb') do |rvdata2file|
            rvdata2file.write(rvdata2)
        end
    end
end
