#!/usr/bin/env ruby
require 'oj'
require 'zlib'
require 'fileutils'
require_relative 'RGSS3'

def to_rvdata2_Scripts
    scripts_array = []
    scripts_info = nil
    File.open("JSON_all/Scripts/Scripts_info.json") { |file| scripts_info = Oj.load(file) }

    [*Dir.glob("JSON_all/Scripts/[0-9][0-9][0-9].rb")].each_with_index do |scriptpath, index|
        File.open(scriptpath, 'r') { |scriptfile| scripts_array << [0, scripts_info[index], Zlib::Deflate.deflate(scriptfile.read).force_encoding('UTF-8')] }
    end
    File.open("Data_New/Scripts.rvdata2", 'wb') { |file| Marshal.dump(scripts_array, file) }
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
    print "\e[33mReading \e[0m#{jsonpath}...\r"
    File.open(jsonpath, 'r') do |jsonfile|
        print "\e[2K\e[34mUnserializing \e[0m#{jsonpath}...\r"
        object = Oj.load(jsonfile)
        File.open("Data_New/#{jsonbasename}.rvdata2", 'wb') { |file| Marshal.dump(object, file) }
    end
    print "\e[2K\e[32mUnserialized \e[0m#{jsonpath}\n"
end

# 单独处理Scripts
scriptspath = 'JSON_all/Scripts/*.rb'
print "\e[33mReading \e[0m#{scriptspath}...\r"
to_rvdata2_Scripts
print "\e[2K\e[32mUnserialized \e[0m#{scriptspath}\n"
