require 'oj'
require 'zlib'
require 'fileutils'
require_relative 'RGSS3'

def to_rvdata2_Scripts(scripts)
    scripts_array = []
    [*Dir.glob("JSON/Scripts/*.rb")].each do |script|
        script_basename = File.basename(script, '.*')
        File.open(script, 'r') do |file|
            scripts_array[script_basename.to_i] = file.read
        end
    end
    scripts_array.each_with_index do |script, index|
        scripts[index][2] = Zlib::Deflate.deflate(script).force_encoding('UTF-8')
    end
    File.open("Data_New/Scripts.rvdata2", 'wb') { |file| file.write(Marshal.dump(scripts)) }
end

FileUtils.mkdir_p('Data_New') unless Dir.exist?('Data_New')
[
    'JSON_all/Actors.json',
    'JSON_all/Animations.json',
    'JSON_all/Armors.json',
    'JSON_all/Classes.json',
    'JSON_all/CommonEvents.json',
    'JSON_all/Enemies.json',
    'JSON_all/Items.json',
    *Dir.glob('JSON_all/Map[0-9][0-9][0-9].json'),
    'JSON_all/MapInfos.json',
    'JSON_all/Skills.json',
    'JSON_all/States.json',
    'JSON_all/System.json',
    'JSON_all/Tilesets.json',
    'JSON_all/Troops.json',
    'JSON_all/Weapons.json'
].each do |jsonpath|
    jsonbasename = File.basename(jsonpath, '.*')
    print "\e[33mReading \e[37m#{jsonpath}\e[0m...\r"
    File.open(jsonpath, 'r') do |jsonfile|
        print "\e[2K\e[34mUnserializing \e[37m#{jsonpath}\e[0m...\r"
        object = Oj.load(jsonfile)
        File.open("Data_New/#{jsonbasename}.rvdata2", 'wb') { |file| Marshal.dump(object, file) }
    end
    print "\e[2K\e[32mUnserialized \e[37m#{jsonpath}\e[0m.\n"
end

# 单独处理Scripts
rvdata2path = 'Data/Scripts.rvdata2'
rvdata2basename = File.basename(rvdata2path, '.*')
print "\e[33mReading \e[37m#{rvdata2path}\e[0m...\r"
File.open(rvdata2path, 'r') do |rvdata2file|
    print "\e[2K\e[34mUnserializing \e[37m#{rvdata2path}\e[0m...\r"
    object = Marshal.load(rvdata2file)
    to_rvdata2_Scripts(object)
end
print "\e[2K\e[32mUnserialized \e[37m#{rvdata2path}\e[0m.\n"
