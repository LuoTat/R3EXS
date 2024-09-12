#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>    // mkdir

#define MOD_4_MASK 0b11
#define MASK_KEY_1 0x000000FF
#define MASK_KEY_2 0x0000FFFF
#define MASK_KEY_3 0x00FFFFFF


// 解包文件路径
const char* Rgss3aPath = "Game.rgss3a";

// 文件名
char DataName[1024];

// 创建目录（支持递归创建）
void CreateDirectories(char* Dir, size_t Size)
{
    // 遍历路径字符串
    for (size_t i = 0; i < Size; ++i)
    {
        if (Dir[i] == '\\')
        {
            // 暂时把 '\\' 替换为字符串结束符 '\0'
            Dir[i] = '\0';
            // 创建目录，忽略目录已经存在的情况
            mkdir(Dir, 0777);
            // 把'\\'换为 '/'
            Dir[i] = '/';
        }
    }
}

// 解密文件名
void DecryptDataName(unsigned char* Data, size_t Size, unsigned int MagicKey)
{
    size_t        q      = Size >> 2;
    char          r      = Size & MOD_4_MASK;
    unsigned int* Data_p = (unsigned int*)Data;
    for (; Data_p < (unsigned int*)(Data + q * 4); ++Data_p) *Data_p ^= MagicKey;
    switch (r)
    {
        case 1 : *Data_p ^= (MagicKey & MASK_KEY_1); break;
        case 2 : *Data_p ^= (MagicKey & MASK_KEY_2); break;
        case 3 : *Data_p ^= (MagicKey & MASK_KEY_3); break;
    }
}

// 解密数据段
void DecryptData(unsigned char* Data, size_t Size, unsigned int MagicKey)
{
    size_t        q      = Size >> 2;
    char          r      = Size & MOD_4_MASK;
    unsigned int* Data_p = (unsigned int*)Data;
    for (; Data_p < (unsigned int*)(Data + q * 4); ++Data_p)
    {
        *Data_p  ^= MagicKey;
        MagicKey  = MagicKey * 7 + 3;
    }
    switch (r)
    {
        case 1 : *Data_p ^= (MagicKey & MASK_KEY_1); break;
        case 2 : *Data_p ^= (MagicKey & MASK_KEY_2); break;
        case 3 : *Data_p ^= (MagicKey & MASK_KEY_3); break;
    }
}

int main()
{
    printf("\e[33mReading \e[37m%s\e[0m...\r", Rgss3aPath);

    FILE* Rgss3aFile = fopen(Rgss3aPath, "rb");
    if (!Rgss3aFile)
    {
        perror("Failed to open file\n");
        return 1;
    }

    // 获取文件大小
    fseek(Rgss3aFile, 0, SEEK_END);
    long int Rgss3aSize = ftell(Rgss3aFile);
    fseek(Rgss3aFile, 0, SEEK_SET);

    unsigned char* Rgss3aData = (unsigned char*)malloc(sizeof(unsigned char) * Rgss3aSize);
    if (!Rgss3aData)
    {
        perror("Failed to allocate memory\n");
        fclose(Rgss3aFile);
        return 1;
    }

    // 把整个文件读到内存中
    size_t result = fread(Rgss3aData, sizeof(unsigned char), Rgss3aSize, Rgss3aFile);
    if (result != Rgss3aSize)
    {
        // 处理错误，可能是文件读取失败，或读取到的字节数与预期不符
        perror("File read error\n");
        free(Rgss3aData);
        fclose(Rgss3aFile);
        return 1;
    }
    printf("\e[2K\e[32mReaded \e[37m%s\e[0m\n", Rgss3aPath);

    // 文件指针索引
    unsigned char* Rgss3a_P = Rgss3aData;

    // 前8字节为 "RGSSAD\x00\x03"
    if (memcmp(Rgss3a_P, "RGSSAD\x00\x03", 8) != 0)
    {
        printf("Invalid RGSSAD file\n");
        free(Rgss3aData);
        fclose(Rgss3aFile);
        return 1;
    }
    Rgss3a_P              += 8;

    // 读取 MagicKey
    unsigned int MagicKey  = *(unsigned int*)Rgss3a_P * 9 + 3;
    Rgss3a_P              += 4;

    while (1)
    {
        // 读取数据段偏移量
        unsigned int DataOffset = *(unsigned int*)Rgss3a_P ^ MagicKey;
        if (DataOffset == 0) break;
        Rgss3a_P                  += 4;

        // 读取数据段长度
        unsigned int DataSize      = *(unsigned int*)Rgss3a_P ^ MagicKey;
        Rgss3a_P                  += 4;

        // 读取数据段 magicKey
        unsigned int DataMagicKey  = *(unsigned int*)Rgss3a_P ^ MagicKey;
        Rgss3a_P                  += 4;

        // 读取文件名长度
        unsigned int DataNameSize  = *(unsigned int*)Rgss3a_P ^ MagicKey;
        Rgss3a_P                  += 4;

        // 解码文件名
        printf("\e[34mDecrypting DataName...\r");
        DecryptDataName(Rgss3a_P, DataNameSize, MagicKey);

        // 确保目录结构存在
        CreateDirectories((char*)Rgss3a_P, DataNameSize);

        // 把文件名转为字符串
        memcpy(DataName, Rgss3a_P, DataNameSize);
        DataName[DataNameSize] = '\0';

        // 解码数据段
        printf("\e[2K\e[32mDecrypting \e[37m%s \e[37mOffset: \e[35m%u \e[37mSize: \e[35m%u \e[37mMagicKey: \e[35m%u\e[0m...\r", DataName, DataOffset, DataSize, DataMagicKey);
        DecryptData(Rgss3aData + DataOffset, DataSize, DataMagicKey);
        printf("\e[2K\e[32mDecrypted \e[37m%s \e[37mOffset: \e[35m%u \e[37mSize: \e[35m%u \e[37mMagicKey: \e[35m%u\e[0m\n", DataName, DataOffset, DataSize, DataMagicKey);

        // 写入解密后的数据到文件
        printf("\e[34mWriting \e[37m%s\e[0m...\r", DataName);
        FILE* OutputFile = fopen(DataName, "wb");
        if (OutputFile)
        {
            fwrite(Rgss3aData + DataOffset, sizeof(unsigned char), DataSize, OutputFile);
            fclose(OutputFile);
        }
        printf("\e[2K\e[32mWrited \e[37m%s\e[0m\n", DataName);

        Rgss3a_P += DataNameSize;
    }

    free(Rgss3aData);
    fclose(Rgss3aFile);
    printf("\e[32mFinished\e[0m\n");
    return 0;
}
