#!/usr/bin/env ruby
require 'oj'
require 'zlib'
require 'json'
require 'fileutils'
require_relative 'RGSS3'

def to_json_Scripts(scripts)
    FileUtils.mkdir_p('JSON_all/Scripts') unless Dir.exist?('JSON_all/Scripts')
    scripts_info = {}
    scripts.each_with_index do |script, index|
        scripts_info[index] = script[1]
        File.open("JSON_all/Scripts/#{sprintf('%03d', index)}.rb", 'w') { |file| file.write(Zlib::Inflate.inflate(script[2]).force_encoding('UTF-8')) }
    end
    File.open("JSON_all/Scripts/Scripts_info.json", 'w') { |file| file.write(Oj.dump(scripts_info, :indent => 4)) }
end

FileUtils.mkdir_p('JSON_all') unless Dir.exist?('JSON_all')
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
    print "\e[33mReading \e[0m#{rvdata2path}...\r"
    File.open(rvdata2path, 'rb') do |rvdata2file|
        print "\e[2K\e[34mSerializing \e[0m#{rvdata2path}...\r"
        object = Marshal.load(rvdata2file)
        if rvdata2basename == 'Scripts'
            to_json_Scripts(object)
        else
            File.open("JSON_all/#{rvdata2basename}.json", 'w') { |file| file.write(Oj.dump(object, :indent => 2)) }
        end
    end
    print "\e[2K\e[32mSerialized \e[0m#{rvdata2path}\n"
end