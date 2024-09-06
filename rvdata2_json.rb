require 'oj'
require 'fileutils'
require_relative 'RGSS3'

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
    # 'Data/Scripts.rvdata2',
    'Data/Skills.rvdata2',
    'Data/States.rvdata2',
    'Data/System.rvdata2',
    'Data/Tilesets.rvdata2',
    'Data/Troops.rvdata2',
    'Data/Weapons.rvdata2'
].each do |rvdata2path|
    puts rvdata2path
    File.open(rvdata2path, 'rb') do |rvdata2file|
        # 从二进制文件反序列化对象
        object = Marshal.load(rvdata2file.read)
        # 将对象序列化为 JSON 字符串
        json = Oj.dump(object)
        # 将 JSON 字符串写入文件
        File.open('JSON/' + File.basename(rvdata2path, '.*') + '.json', 'w') do |jsonfile|
            jsonfile.write(json)
        end
    end
end