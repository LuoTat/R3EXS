#include "ruby.h"

#ifdef _WIN32
wchar_t*       wchar_arr      = NULL;
unsigned short wchar_arr_size = 0;

/*
 * 将指定长度的 UTF-8 字符串转换为 wchar 字符串
 * wchar 字符串会被存储在 wchar_arr 中
 * 同时更新 wchar_arr_size
 * 
 * @param utf8char UTF-8 字符串
 * @param n 字符串长度
 * @return 0 成功，-1 失败
 */
int utf8towc(const char* utf8char, size_t n)
{
    // 计算转换为 wchar 所需的缓冲区大小，包括结尾的 '\0'
    int wc_size = MultiByteToWideChar(CP_UTF8, 0, utf8char, n, NULL, 0) + 1;
    if (wc_size == 0)
    {
        errno = EILSEQ;
        return -1;
    }
    if (wc_size > wchar_arr_size)
    {
        wchar_t* wchar_arr_new = (wchar_t*)realloc(wchar_arr, sizeof(wchar_t) * wc_size);
        if (!wchar_arr_new)
            return -1;
        wchar_arr      = wchar_arr_new;
        wchar_arr_size = wc_size;
    }

    // 执行从 UTF-8 到 wchar 的转换
    MultiByteToWideChar(CP_UTF8, 0, utf8char, n, wchar_arr, wchar_arr_size);
    // 添加结尾的 '\0'
    wchar_arr[wc_size - 1] = L'\0';
    return 0;
}

/*
 * 处理 utf8towc 错误
 *
 * @return [void]
 */
void utf8towc_error_handler(void)
{
    rb_sys_fail("Failed to convert UTF-8 to wchar");
}
#endif

#ifdef __linux__
char*          char_arr      = NULL;
unsigned short char_arr_size = 0;

/*
 * 将指定长度的 UTF-8 字符串 转换为 char 字符串
 * char 字符串会被存储在 char_arr 中
 * 同时更新 char_arr_size
 *
 * @param utf8char UTF-8 字符串
 * @param n 字符串长度
 * @return 0 成功，-1 失败
 */
int utf8tomb(const char* utf8char, size_t n)
{
    // 计算转换为 char 所需的缓冲区大小，包括结尾的 '\0'
    int mb_size = n + 1;
    if (mb_size > char_arr_size)
    {
        char* char_arr_new = (char*)realloc(char_arr, sizeof(char) * mb_size);
        if (!char_arr_new)
            return -1;
        char_arr      = char_arr_new;
        char_arr_size = mb_size;
    }
    memcpy(char_arr, utf8char, n);
    char_arr[mb_size - 1] = '\0';
    return 0;
}

/*
 * 处理 utf8tomb 错误
 *
 * @return [void]
 */
void utf8tomb_error_handler(void)
{
    rb_sys_fail("Failed to convert UTF-8 to char");
}
#endif

#define MOD_4_MASK 0b11
#define MASK_KEY_1 0x000000FF
#define MASK_KEY_2 0x0000FFFF
#define MASK_KEY_3 0x00FFFFFF

// 解码文件类型
enum RGSSAD_DECRYPT_TYPE
{
    RGSSAD,
    Fux2Pack2
};

/*
 * 解码文件名
 *
 * @param data 文件名指针
 * @param n 文件名长度
 * @param magickey 解密密钥
 * @return [void]
 */
void decrypt_file_name(unsigned char* data, size_t n, unsigned int magickey)
{
    size_t        q      = n >> 2;
    char          r      = n & MOD_4_MASK;
    unsigned int* data_p = (unsigned int*)data;
    for (; data_p < (unsigned int*)(data + q * 4); ++data_p) *data_p ^= magickey;
    switch (r)
    {
        case 1 : *data_p ^= (magickey & MASK_KEY_1); break;
        case 2 : *data_p ^= (magickey & MASK_KEY_2); break;
        case 3 : *data_p ^= (magickey & MASK_KEY_3); break;
    }
}

/*
 * 解码数据段
 *
 * @param data 数据段指针
 * @param n 数据段长度
 * @param magickey 解密密钥
 * @return [void]
 */
void decrypt_file_data(unsigned char* data, size_t n, unsigned int magickey)
{
    size_t        q      = n >> 2;
    char          r      = n & MOD_4_MASK;
    unsigned int* data_p = (unsigned int*)data;
    for (; data_p < (unsigned int*)(data + q * 4); ++data_p)
    {
        *data_p  ^= magickey;
        magickey  = magickey * 7 + 3;
    }
    switch (r)
    {
        case 1 : *data_p ^= (magickey & MASK_KEY_1); break;
        case 2 : *data_p ^= (magickey & MASK_KEY_2); break;
        case 3 : *data_p ^= (magickey & MASK_KEY_3); break;
    }
}

/*
 * 处理 mkdir 错误
 *
 * @param dir 目录
 * @return [void]
 */
void mkdir_error_handler(const char* dir)
{
    rb_sys_fail(dir);
}

/*
 * 处理 malloc 错误
 *
 * @return [void]
 */
void malloc_error_handler(void)
{
    rb_sys_fail("Failed to allocate memory");
}

/*
 * 处理 fopen 错误
 *
 * @param path 文件路径
 * @return [void]
 */
void fopen_error_handler(const char* path)
{
    rb_sys_fail(path);
}

/*
 * 处理 fseek 错误
 *
 * @param path 文件路径
 * @return [void]
 */
void fseek_error_handler(const char* path)
{
    rb_sys_fail(path);
}

/*
 * 处理 ftell 错误
 *
 * @param path 文件路径
 * @return [void]
 */
void ftell_error_handler(const char* path)
{
    rb_sys_fail(path);
}

/*
 * 处理 fread 错误
 *
 * @param path 文件路径
 * @return [void]
 */
void fread_error_handler(const char* path)
{
    rb_sys_fail(path);
}

/*
 * 处理 fwrite 错误
 *
 * @param path 文件路径
 * @return [void]
 */
void fwrite_error_handler(const char* path)
{
    rb_sys_fail(path);
}

/*
 * 处理 fclose 错误
 *
 * @param path 文件路径
 * @return [void]
 */
void fclose_error_handler(const char* path)
{
    rb_sys_fail(path);
}

/*
 * 解码 Game.rgss3a 文件中的 rvdata2 数据
 *
 * @param target_path Game.rgss3a 文件路径
 * @param output_dir 输出目录
 * @param verbose 是否输出详细信息
 * @raise [Errno] 系统调用失败
 * @raise [TypeError] 未知的 RGSS3A 文件加密类型
 * @return [void]
 */
VALUE rb_rgss3a_rvdata2(VALUE self, VALUE target_path, VALUE output_dir, VALUE verbose)
{
    bool verbose_bool   = RTEST(verbose);
    // 首先将 Ruby 的 VALUE 转换为 C 的字符串
    char* target_path_C = StringValueCStr(target_path);
    char* output_dir_C  = StringValueCStr(output_dir);

    // 创建 output_dir
#ifdef _WIN32
    if (utf8towc(output_dir_C, strlen(output_dir_C)) == -1)
    {
        free(wchar_arr);
        utf8towc_error_handler();
    }
    if (_wmkdir(wchar_arr) == -1 && errno != EEXIST)
    {
        free(wchar_arr);
        mkdir_error_handler(output_dir_C);
    }
#endif
#ifdef __linux__
    if (mkdir(output_dir_C, 0755) == -1 && errno != EEXIST)
    {
        free(char_arr);
        mkdir_error_handler(output_dir_C);
    }
#endif

    // 打开文件
#ifdef _WIN32
    if (utf8towc(target_path_C, strlen(target_path_C)) == -1)
    {
        free(wchar_arr);
        utf8towc_error_handler();
    }
    FILE* Rgss3a_file = _wfopen(wchar_arr, L"rb");
    if (!Rgss3a_file)
    {
        free(wchar_arr);
        fopen_error_handler(target_path_C);
    }
#endif
#ifdef __linux__
    FILE* Rgss3a_file = fopen(target_path_C, "rb");
    if (!Rgss3a_file)
    {
        free(char_arr);
        fopen_error_handler(target_path_C);
    }
#endif

    // 获取文件大小
    if (fseek(Rgss3a_file, 0, SEEK_END) == -1)
    {
#ifdef _WIN32
        free(wchar_arr);
#endif
#ifdef __linux__
        free(char_arr);
#endif
        if (fclose(Rgss3a_file) == EOF)
            fclose_error_handler(target_path_C);
        fseek_error_handler(target_path_C);
    }
    long int Rgss3a_file_size = ftell(Rgss3a_file);
    if (Rgss3a_file_size == -1)
    {
#ifdef _WIN32
        free(wchar_arr);
#endif
#ifdef __linux__
        free(char_arr);
#endif
        if (fclose(Rgss3a_file) == EOF)
            fclose_error_handler(target_path_C);
        ftell_error_handler(target_path_C);
    }
    if (fseek(Rgss3a_file, 0, SEEK_SET) == -1)
    {
#ifdef _WIN32
        free(wchar_arr);
#endif
#ifdef __linux__
        free(char_arr);
#endif
        if (fclose(Rgss3a_file) == EOF)
            fclose_error_handler(target_path_C);
        fseek_error_handler(target_path_C);
    }

    // 分配内存
    unsigned char* Rgss3a_data = (unsigned char*)malloc(sizeof(unsigned char) * Rgss3a_file_size);
    if (!Rgss3a_data)
    {
#ifdef _WIN32
        free(wchar_arr);
#endif
#ifdef __linux__
        free(char_arr);
#endif
        if (fclose(Rgss3a_file) == EOF)
            fclose_error_handler(target_path_C);
        malloc_error_handler();
    }

    // 把整个文件读到内存中
    size_t result = fread(Rgss3a_data, sizeof(unsigned char), Rgss3a_file_size, Rgss3a_file);
    if (result < Rgss3a_file_size)
    {
#ifdef _WIN32
        free(wchar_arr);
#endif
#ifdef __linux__
        free(char_arr);
#endif
        free(Rgss3a_data);
        if (fclose(Rgss3a_file) == EOF)
            fclose_error_handler(target_path_C);
        fread_error_handler(target_path_C);
    }

    // 关闭文件
    if (fclose(Rgss3a_file) == EOF)
        fclose_error_handler(target_path_C);
#ifdef _WIN32
    if (verbose_bool)
        printf("\e[2K\e[32mReaded \e[0m%ls\n", wchar_arr);
#endif
#ifdef __linux__
    if (verbose_bool)
        printf("\e[2K\e[32mReaded \e[0m%s\n", target_path_C);
#endif

    // 设置文件指针索引
    unsigned char* Rgss3a_p = Rgss3a_data;

    // 判断加密类型
    enum RGSSAD_DECRYPT_TYPE decrypt_type;
    if (memcmp(Rgss3a_p, "RGSSAD\x00\x03", 8) == 0)
    {
        decrypt_type = RGSSAD;
    }
    else if (memcmp(Rgss3a_p, "Fux2Pack", 8) == 0)
    {
        decrypt_type = Fux2Pack2;
    }
    else
    {
#ifdef _WIN32
        free(wchar_arr);
#endif
#ifdef __linux__
        free(char_arr);
#endif
        free(Rgss3a_data);
        rb_raise(rb_eTypeError, "Unknown RGSS3A file type: %s", target_path_C);
    }

    // 读取 MagicKey
    Rgss3a_p += 8;
    unsigned int magickey;
    switch (decrypt_type)
    {
        case RGSSAD :
            magickey = *(unsigned int*)Rgss3a_p * 9 + 3;
            break;
        case Fux2Pack2 :
            magickey = *(unsigned int*)Rgss3a_p;
            break;
    }
    Rgss3a_p += 4;

    while (1)
    {
        // 读取数据段偏移量
        unsigned int data_offset = *(unsigned int*)Rgss3a_p ^ magickey;
        if (data_offset == 0) break;
        Rgss3a_p                   += 4;

        // 读取数据段长度
        unsigned int data_size      = *(unsigned int*)Rgss3a_p ^ magickey;
        Rgss3a_p                   += 4;

        // 读取数据段 magicKey
        unsigned int data_magickey  = *(unsigned int*)Rgss3a_p ^ magickey;
        Rgss3a_p                   += 4;

        // 读取文件名长度
        unsigned int filename_size  = *(unsigned int*)Rgss3a_p ^ magickey;
        Rgss3a_p                   += 4;

        // 解码文件名
        if (verbose_bool)
            printf("\e[34mDecrypting DataName...\r");
        decrypt_file_name(Rgss3a_p, filename_size, magickey);

        // 读取文件名
#ifdef _WIN32
        if (utf8towc((char*)Rgss3a_p, filename_size) == -1)
        {
            free(wchar_arr);
            free(Rgss3a_data);
            utf8towc_error_handler();
        }
#endif
#ifdef __linux__
        if (utf8tomb((char*)Rgss3a_p, filename_size) == -1)
        {
            free(char_arr);
            free(Rgss3a_data);
            utf8tomb_error_handler();
        }
#endif

        // 解码数据段
#ifdef _WIN32
        if (verbose_bool)
            printf("\e[2K\e[32mDecrypting \e[0m%ls \e[0mOffset: \e[35m%u \e[0mSize: \e[35m%u \e[0mMagicKey: \e[35m%u\e[0m...\r", wchar_arr, data_offset, data_size, data_magickey);
#endif
#ifdef __linux__
        if (verbose_bool)
            printf("\e[2K\e[32mDecrypting \e[0m%s \e[0mOffset: \e[35m%u \e[0mSize: \e[35m%u \e[0mMagicKey: \e[35m%u\e[0m...\r", char_arr, data_offset, data_size, data_magickey);
#endif
        decrypt_file_data(Rgss3a_data + data_offset, data_size, data_magickey);
#ifdef _WIN32
        if (verbose_bool)
            printf("\e[2K\e[32mDecrypted \e[0m%ls \e[0mOffset: \e[35m%u \e[0mSize: \e[35m%u \e[0mMagicKey: \e[35m%u\e[0m\n", wchar_arr, data_offset, data_size, data_magickey);
#endif
#ifdef __linux__
        if (verbose_bool)
            printf("\e[2K\e[32mDecrypted \e[0m%s \e[0mOffset: \e[35m%u \e[0mSize: \e[35m%u \e[0mMagicKey: \e[35m%u\e[0m\n", char_arr, data_offset, data_size, data_magickey);
#endif

        // 写入解密后的数据到文件

        // 先将 output_dir 和文件名拼接得到 output_full_path
        // 再通过 File.dirname(output_full_path) 获得 output_full_dir
        // 最后通过 FileUtils.mkdir_p(output_full_dir) 递归创建目录
        VALUE rb_mFile         = rb_const_get(rb_cObject, rb_intern("File"));
        VALUE rb_mFileUtils    = rb_const_get(rb_cObject, rb_intern("FileUtils"));
        VALUE output_full_path = rb_funcall(rb_mFile, rb_intern("join"), 2, output_dir, rb_utf8_str_new(Rgss3a_p, filename_size));
        VALUE output_full_dir  = rb_funcall(rb_mFile, rb_intern("dirname"), 1, output_full_path);
        rb_funcall(rb_mFileUtils, rb_intern("mkdir_p"), 1, output_full_dir);
        char* output_full_path_C = StringValueCStr(output_full_path);
#ifdef _WIN32
        utf8towc(output_full_path_C, strlen(output_full_path_C));
        if (verbose_bool)
            printf("\e[34mWriting \e[0m%ls...\r", wchar_arr);
        FILE* output_file = _wfopen(wchar_arr, L"wb");
        if (!output_file)
        {
            free(wchar_arr);
            free(Rgss3a_data);
            fopen_error_handler(output_full_path_C);
        }
#endif
#ifdef __linux__
        if (verbose_bool)
            printf("\e[34mWriting \e[0m%s...\r", output_full_path_C);
        FILE* output_file = fopen(output_full_path_C, "wb");
        if (!output_file)
        {
            free(char_arr);
            free(Rgss3a_data);
            fopen_error_handler(output_full_path_C);
        }
#endif
        // 写入文件
        result = fwrite(Rgss3a_data + data_offset, sizeof(unsigned char), data_size, output_file);
        if (result < data_size)
        {
#ifdef _WIN32
            free(wchar_arr);
#endif
#ifdef __linux__
            free(char_arr);
#endif
            free(Rgss3a_data);
            if (fclose(output_file) == EOF)
                fclose_error_handler(output_full_path_C);
            fwrite_error_handler(output_full_path_C);
        }
        if (fclose(output_file) == EOF)
            fclose_error_handler(output_full_path_C);
#ifdef _WIN32
        if (verbose_bool)
            printf("\e[2K\e[32mWrited \e[0m%ls\n", wchar_arr);
#endif
#ifdef __linux__
        if (verbose_bool)
            printf("\e[2K\e[32mWrited \e[0m%s\n", output_full_path_C);
#endif
        Rgss3a_p += filename_size;
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

/*
 * 初始化 R3EXS 模块方法 rgss3a_rvdata2
 *
 * @return [void]
 */
void Init_rgss3a_rvdata2()
{
    // 定义 Ruby 模块
    VALUE rb_mR3EXS = rb_define_module("R3EXS");
    rb_define_singleton_method(rb_mR3EXS, "rgss3a_rvdata2", rb_rgss3a_rvdata2, 3);
}
