#include "ruby.h"
#include <locale.h>

#ifdef _WIN32
wchar_t*       wchar_arr      = NULL;
unsigned short wchar_arr_size = 0;

// 将指定长度的 UTF-8 字符串 转换为 WCHAR
void utf8_wchar(const char* str_utf8, int length)
{
    // 计算转换为 WCHAR 所需的缓冲区大小，包括结尾的 '\0'
    int WCHAR_size = MultiByteToWideChar(CP_UTF8, 0, str_utf8, length, NULL, 0) + 1;
    if (WCHAR_size > wchar_arr_size)
    {
        wchar_t* wchar_arr_new = (wchar_t*)realloc(wchar_arr, sizeof(wchar_t) * WCHAR_size);
        if (!wchar_arr_new)
        {
            free(wchar_arr);
            rb_raise(rb_eNoMemError, "Failed to allocate memory");
        }
        wchar_arr      = wchar_arr_new;
        wchar_arr_size = WCHAR_size;
    }

    // 执行从 UTF-8 到 WCHAR 的转换
    MultiByteToWideChar(CP_UTF8, 0, str_utf8, length, wchar_arr, wchar_arr_size);
    // 添加结尾的 '\0'
    wchar_arr[WCHAR_size - 1] = L'\0';
}
#endif

#ifdef __linux__
char*          char_arr      = NULL;
unsigned short char_arr_size = 0;

// 将指定长度的 UTF-8 字符串 转换为 CHAR
void utf8_char(const char* str_utf8, int length)
{
    // 计算转换为 CHAR 所需的缓冲区大小，包括结尾的 '\0'
    int CHAR_size = length + 1;
    if (CHAR_size > char_arr_size)
    {
        char* char_arr_new = (char*)realloc(char_arr, sizeof(char) * CHAR_size);
        if (!char_arr_new)
        {
            free(char_arr);
            rb_raise(rb_eNoMemError, "Failed to allocate memory");
        }
        char_arr      = char_arr_new;
        char_arr_size = CHAR_size;
    }
    memcpy(char_arr, str_utf8, length);
    char_arr[CHAR_size - 1] = '\0';
}
#endif

#define MOD_4_MASK 0b11
#define MASK_KEY_1 0x000000FF
#define MASK_KEY_2 0x0000FFFF
#define MASK_KEY_3 0x00FFFFFF

// 解码文件类型
enum RGSSAD_DECRIPT_TYPE
{
    RGSSAD,
    Fux2Pack2
};

// 解密文件名
void decrypt_file_name(unsigned char* Data, size_t Size, unsigned int MagicKey)
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
void decrypt_file_data(unsigned char* Data, size_t Size, unsigned int MagicKey)
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

VALUE rgss3a_rvdata2(VALUE self, VALUE target_path, VALUE output_dir, VALUE verbose)
{
    bool verbose_bool   = RTEST(verbose);
    // 首先将 Ruby 的 VALUE 转换为 C 的字符串
    char* target_path_C = StringValueCStr(target_path);
    char* output_dir_C  = StringValueCStr(output_dir);

    // 如果 output_dir 不存在，则创建 output_dir
#ifdef _WIN32
    utf8_wchar(output_dir_C, strlen(output_dir_C));
    if (_waccess(wchar_arr, F_OK) == -1)
    {
        if (_wmkdir(wchar_arr) == -1 && errno != EEXIST)
        {
            free(wchar_arr);
            rb_raise(rb_const_get(rb_mErrno, rb_intern("EACCES")), "Failed to create directory: %s", output_dir_C);
        }
    }
#endif
#ifdef __linux__
    if (access(output_dir_C, F_OK) == -1)
    {
        if (mkdir(output_dir_C, 0755) == -1 && errno != EEXIST)
        {
            rb_raise(rb_const_get(rb_mErrno, rb_intern("EACCES")), "Failed to create directory: %s", output_dir_C);
        }
    }
#endif

    // 如果 target_path 不存在，则抛出异常
#ifdef _WIN32
    utf8_wchar(target_path_C, strlen(target_path_C));
    if (_waccess(wchar_arr, F_OK) == -1)
    {
        free(wchar_arr);
        rb_raise(rb_const_get(rb_mErrno, rb_intern("ENOENT")), "Game.rgss3a file does not exist: %s", target_path_C);
    }
#endif
#ifdef __linux__
    if (access(target_dir_C, F_OK) == -1)
    {
        free(char_arr);
        rb_raise(rb_const_get(rb_mErrno, rb_intern("ENOENT")), "Game.rgss3a file does not exist: %s", target_path_C);
    }
#endif

    // 打开文件
#ifdef _WIN32
    FILE* Rgss3a_file = _wfopen(wchar_arr, L"rb");
    if (!Rgss3a_file)
    {
        free(wchar_arr);
        rb_raise(rb_const_get(rb_mErrno, rb_intern("EACCES")), "Failed to open file: %s", target_path_C);
    }
#endif
#ifdef __linux__
    FILE* Rgss3a_file = fopen(target_path_C, "rb");
    if (!Rgss3a_file)
    {
        rb_raise(rb_const_get(rb_mErrno, rb_intern("EACCES")), "Failed to open file: %s", target_path_C);
    }
#endif

    // 获取文件大小
    fseek(Rgss3a_file, 0, SEEK_END);
    long int Rgss3a_file_size = ftell(Rgss3a_file);
    fseek(Rgss3a_file, 0, SEEK_SET);

    // 分配内存
    unsigned char* Rgss3a_data = (unsigned char*)malloc(sizeof(unsigned char) * Rgss3a_file_size);
    if (!Rgss3a_data)
    {
#ifdef _WIN32
        free(wchar_arr);
#endif
        fclose(Rgss3a_file);
        rb_raise(rb_eNoMemError, "Failed to allocate memory");
    }

    // 把整个文件读到内存中
    size_t result = fread(Rgss3a_data, sizeof(unsigned char), Rgss3a_file_size, Rgss3a_file);
    if (result != (size_t)Rgss3a_file_size)
    {
#ifdef _WIN32
        free(wchar_arr);
#endif
        free(Rgss3a_data);
        fclose(Rgss3a_file);
        rb_raise(rb_const_get(rb_mErrno, rb_intern("EIO")), "Failed to read file: %s", target_path_C);
    }

    // 关闭文件
    fclose(Rgss3a_file);
#ifdef _WIN32
    if (verbose_bool)
        printf("\e[2K\e[32mReaded \e[0m%ls\n", wchar_arr);
#endif
#ifdef __linux__
    if (verbose_bool)
        printf("\e[2K\e[32mReaded \e[0m%s\n", target_path_C);
#endif

    // 设置文件指针索引
    unsigned char* Rgss3a_P = Rgss3a_data;

    // 判断加密类型
    enum RGSSAD_DECRIPT_TYPE DecrptType;
    if (memcmp(Rgss3a_P, "RGSSAD\x00\x03", 8) == 0)
    {
        DecrptType = RGSSAD;
    }
    else if (memcmp(Rgss3a_P, "Fux2Pack", 8) == 0)
    {
        DecrptType = Fux2Pack2;
    }
    else
    {
#ifdef _WIN32
        free(wchar_arr);
#endif
        free(Rgss3a_data);
        rb_raise(rb_eTypeError, "Unknown RGSS3A file type: %s", target_path_C);
    }

    // 读取 MagicKey
    Rgss3a_P += 8;
    unsigned int MagicKey;
    switch (DecrptType)
    {
        case RGSSAD :
            MagicKey = *(unsigned int*)Rgss3a_P * 9 + 3;
            break;
        case Fux2Pack2 :
            MagicKey = *(unsigned int*)Rgss3a_P;
            break;
    }
    Rgss3a_P += 4;

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
        if (verbose_bool)
            printf("\e[34mDecrypting DataName...\r");
        decrypt_file_name(Rgss3a_P, DataNameSize, MagicKey);

        // 读取文件名
#ifdef _WIN32
        utf8_wchar((char*)Rgss3a_P, DataNameSize);
#endif
#ifdef __linux__
        utf8_char((char*)Rgss3a_P, DataNameSize);
#endif

        // 解码数据段
#ifdef _WIN32
        if (verbose_bool)
            printf("\e[2K\e[32mDecrypting \e[0m%ls \e[0mOffset: \e[35m%u \e[0mSize: \e[35m%u \e[0mMagicKey: \e[35m%u\e[0m...\r", wchar_arr, DataOffset, DataSize, DataMagicKey);
#endif
#ifdef __linux__
        if (verbose_bool)
            printf("\e[2K\e[32mDecrypting \e[0m%s \e[0mOffset: \e[35m%u \e[0mSize: \e[35m%u \e[0mMagicKey: \e[35m%u\e[0m...\r", char_arr, DataOffset, DataSize, DataMagicKey);
#endif
        decrypt_file_data(Rgss3a_data + DataOffset, DataSize, DataMagicKey);
#ifdef _WIN32
        if (verbose_bool)
            printf("\e[2K\e[32mDecrypted \e[0m%ls \e[0mOffset: \e[35m%u \e[0mSize: \e[35m%u \e[0mMagicKey: \e[35m%u\e[0m\n", wchar_arr, DataOffset, DataSize, DataMagicKey);
#endif
#ifdef __linux__
        if (verbose_bool)
            printf("\e[2K\e[32mDecrypted \e[0m%s \e[0mOffset: \e[35m%u \e[0mSize: \e[35m%u \e[0mMagicKey: \e[35m%u\e[0m\n", char_arr, DataOffset, DataSize, DataMagicKey);
#endif

        // 写入解密后的数据到文件
#ifdef _WIN32
        VALUE rb_mFile         = rb_const_get(rb_cObject, rb_intern("File"));
        VALUE rb_mFileUtils    = rb_const_get(rb_cObject, rb_intern("FileUtils"));
        VALUE output_full_path = rb_funcall(rb_mFile, rb_intern("join"), 2, output_dir, rb_utf8_str_new(Rgss3a_P, DataNameSize));
        VALUE output_full_dir  = rb_funcall(rb_mFile, rb_intern("dirname"), 1, output_full_path);
        rb_funcall(rb_mFileUtils, rb_intern("mkdir_p"), 1, output_full_dir);
        char* output_full_path_C = StringValueCStr(output_full_path);
        utf8_wchar(output_full_path_C, strlen(output_full_path_C));
        if (verbose_bool)
            printf("\e[34mWriting \e[0m%ls...\r", wchar_arr);
        FILE* OutputFile = _wfopen(wchar_arr, L"wb");
        if (!OutputFile)
        {
            free(wchar_arr);
            free(Rgss3a_data);
            rb_raise(rb_const_get(rb_mErrno, rb_intern("EACCES")), "Failed to open file: %s", wchar_arr);
        }
#endif
#ifdef __linux__
        VALUE rb_mFile         = rb_const_get(rb_cObject, rb_intern("File"));
        VALUE rb_mFileUtils    = rb_const_get(rb_cObject, rb_intern("FileUtils"));
        VALUE output_full_path = rb_funcall(rb_mFile, rb_intern("join"), 2, output_dir, rb_str_utf8_new(Rgss3a_P, DataNameSize));
        VALUE output_full_dir  = rb_funcall(rb_mFile, rb_intern("dirname"), 1, output_full_path);
        rb_funcall(rb_mFileUtils, rb_intern("mkdir_p"), 1, output_full_dir);
        char* output_full_path_C = StringValueCStr(output_full_path);
        if (verbose_bool)
            printf("\e[34mWriting \e[0m%s...\r", output_full_path_C);
        FILE* OutputFile = fopen(output_full_path_C, "wb");
        if (!OutputFile)
        {
            free(char_arr);
            free(Rgss3a_data);
            rb_raise(rb_const_get(rb_mErrno, rb_intern("EACCES")), "Failed to open file: %s", output_full_path_C);
        }
#endif
        // 写入文件
        fwrite(Rgss3a_data + DataOffset, sizeof(unsigned char), DataSize, OutputFile);
        fclose(OutputFile);
#ifdef _WIN32
        if (verbose_bool)
            printf("\e[2K\e[32mWrited \e[0m%ls\n", wchar_arr);
#endif
#ifdef __linux__
        if (verbose_bool)
            printf("\e[2K\e[32mWrited \e[0m%s\n", output_full_path_C);
#endif
        Rgss3a_P += DataNameSize;
    }

#ifdef _WIN32
    free(wchar_arr);
#endif
#ifdef __linux__
    free(char_arr);
#endif
    free(Rgss3a_data);
    return Qnil;
}

// 初始化扩展
void Init_rgss3a_rvdata2()
{
    // 定义 Ruby 模块
    VALUE rb_mR3EXS = rb_define_module("R3EXS");
    rb_define_singleton_method(rb_mR3EXS, "rgss3a_rvdata2", rgss3a_rvdata2, 3);
}
