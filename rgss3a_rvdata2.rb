require 'fileutils'

def decrypt_file_name!(file_name, magicKey)
    # 将 magicKey 转换为字节数组
    magicKey_bytes = [magicKey].pack('L').bytes
    # 将 file_name 转换为字节数组
    file_name_bytes = file_name.bytes

    index = -1
    file_name_bytes.map! do |byte|
        if (index += 1) == 4
            index = 0
        end
        byte ^ magicKey_bytes[index]
    end

    # 将解密后的字节数组转换回原字符串, 并替换所有的反斜杠为正斜杠
    file_name.replace(file_name_bytes.pack('C*').gsub('\\', '/'))
end

def decrypt_data!(data, magicKey)
    # 将 magicKey 转换为字节数组
    magicKey_bytes = [magicKey].pack('L').bytes
    # 将 data 转换为字节数组
    data_bytes = data.bytes
    size = data_bytes.size

    index = -1
    data_bytes.map!.each_with_index do |byte, i|
        print("\r\e[2K\e[33mDecrypting \e[37m#{i}/#{size}\e[0m...")
        if (index += 1) == 4
            index = 0
            magicKey = magicKey * 7 + 3
            magicKey_bytes = [magicKey].pack('L').bytes
        end
        byte ^ magicKey_bytes[index]
    end

    # 将解密后的字节数组转换回原字符串
    data.replace(data_bytes.pack('C*'))
end

# 读取文件
filePath = "Game.rgss3a"
print "\e[33mReading \e[37m#{filePath}\e[0m..."
rgss3afile = File.open(filePath, 'rb')
rgss3afile_data = rgss3afile.read
print "\r\e[2K\e[32mReaded \e[37m#{filePath}\e[0m.\n"
# 文件索引
index = 0

# 前8字节为字符串['R', 'G', 'S', 'S', 'A', 'D',0x00,0x03]
rgss3afile_data[index, 8] == "RGSSAD\x00\x03" or raise "Invalid RGSSAD file"

# 紧接着4个字节，为此加密包的基础key
magicKey = rgss3afile_data[index += 8, 4].unpack1('L') * 9 + 3
index += 4

while (file_offset = rgss3afile_data[index, 4].unpack1('L') ^ magicKey) != 0 # 读取数据段偏移量
    # 读取数据段长度
    file_size = rgss3afile_data[index += 4, 4].unpack1('L') ^ magicKey
    # 读取数据段的magicKey
    file_magicKey = rgss3afile_data[index += 4, 4].unpack1('L') ^ magicKey
    # 读取文件名长度
    filename_size = rgss3afile_data[index += 4, 4].unpack1('L') ^ magicKey
    # 读取文件名
    filename = rgss3afile_data[index += 4, filename_size]
    # 解密文件名
    decrypt_file_name!(filename, magicKey)
    print "\r\e[2K\e[34mDecrypting \e[37m#{filename} \e[37moffset: \e[35m#{file_offset} \e[37msize: \e[35m#{file_size} \e[37mmagicKey: \e[35m#{file_magicKey}\e[0m..."

    # 读取数据段
    file_data = rgss3afile_data[file_offset, file_size]
    # 解密数据段
    file_data = decrypt_data!(file_data, file_magicKey)
    print "\r\e[2K\e[32mDecrypted \e[37m#{filename} \e[37moffset: \e[35m#{file_offset} \e[37msize: \e[35m#{file_size} \e[37mmagicKey: \e[35m#{file_magicKey}\e[0m.\n"

    # 确保目录结构存在
    file_dir = File.dirname(filename)
    FileUtils.mkdir_p(file_dir) unless File.directory?(file_dir)
    print "\r\e[2K\e[34mWriting \e[37m#{filename}\e[0m..."

    # 写入解密后的数据到文件
    File.open(filename, 'wb') do |output_file|
        output_file.write(file_data)
    end
    print "\r\e[2K\e[32mWrited \e[37m#{filename}\e[0m.\n"

    # 更新index
    index += filename_size
end
# 关闭文件
print "\r\e[2K\e[32mFinished.\e[0m\n"

rgss3afile.close