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
static int utf8towc(const char* utf8char, size_t n)
{
    // 计算转换为 wchar 所需的缓冲区大小，包括结尾的 '\0'
    int wc_size = MultiByteToWideChar(CP_UTF8, 0, utf8char, n, NULL, 0) + 1;
    if (wc_size == 1)    // 转换失败
    {
        if (GetLastError() == ERROR_NO_UNICODE_TRANSLATION)
        {
            errno = EILSEQ;
            return -1;
        }
    }
    if (wc_size > wchar_arr_size)
    {
        wchar_t* wchar_arr_new = (wchar_t*)realloc(wchar_arr, sizeof(wchar_t) * wc_size);
        if (!wchar_arr_new)
        {
            errno = ENOMEM;
            return -1;
        }
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
static void utf8towc_error_handler(void)
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
static int utf8tomb(const char* utf8char, const size_t n)
{
    // 计算转换为 char 所需的缓冲区大小，包括结尾的 '\0'
    const size_t mb_size = n + 1;
    if (mb_size > char_arr_size)
    {
        char* char_arr_new = (char*)realloc(char_arr, sizeof(char) * mb_size);
        if (!char_arr_new)
        {
            errno = ENOMEM;
            return -1;
        }
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
static void utf8tomb_error_handler(void)
{
    rb_sys_fail("Failed to convert UTF-8 to char");
}
#endif

VALUE R3EXS = Qnil;

ID r3exs_RGSS3AFileError_id;
ID r3exs_File_id;
ID r3exs_FileUtils_id;
ID r3exs_Dir_id;
ID r3exs_new_id;
ID r3exs_join_id;
ID r3exs_dirname_id;
ID r3exs_exist_id;
ID r3exs_mkdir_p_id;

VALUE r3exs_RGSS3AFileError_class;
VALUE r3exs_File_module;
VALUE r3exs_FileUtils_module;
VALUE r3exs_Dir_module;

// 解码文件类型
enum RGSSAD_DECRYPT_TYPE
{
    RGSSAD,
    Fux2Pack2
};

#if defined(__AVX512F__)
    #include <immintrin.h>
    #define MOD_64_MASK 0b111111
#elif defined(__AVX2__)
    #include <immintrin.h>
    #define MOD_32_MASK 0b11111
#endif

#define MOD_4_MASK 0b11
#define MASK_KEY_1 0x000000FF
#define MASK_KEY_2 0x0000FFFF
#define MASK_KEY_3 0x00FFFFFF

/*
 * 解码文件名
 *
 * @param data 文件名指针
 * @param n 文件名长度
 * @param magickey 解密密钥
 * @return [void]
 */
static void decrypt_file_name(uint8_t* data, const size_t n, const uint32_t magickey)
{
    const size_t q      = n >> 2;
    const char   r      = n & MOD_4_MASK;
    uint32_t*    data_p = (uint32_t*)data;
    for (; data_p < (uint32_t*)(data + q * sizeof(uint32_t)); ++data_p)
        *data_p ^= magickey;
    switch (r)
    {
        case 1 : *data_p ^= (magickey & MASK_KEY_1); break;
        case 2 : *data_p ^= (magickey & MASK_KEY_2); break;
        case 3 : *data_p ^= (magickey & MASK_KEY_3); break;
    }
}

static void decrypt_file_data_scalar(uint8_t* data, const size_t n, uint32_t magickey)
{
    const size_t q      = n >> 2;
    char         r      = n & MOD_4_MASK;
    uint32_t*    data_p = (uint32_t*)data;
    for (; data_p < (uint32_t*)(data + q * sizeof(uint32_t)); ++data_p)
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

#if defined(__AVX512F__)
static void decrypt_file_data_avx512(uint8_t* data, const size_t n, uint32_t magickey)
{
    const size_t q      = n >> 6;    // 64 字节为一组
    const char   r      = n & MOD_64_MASK;
    __m512i*     data_p = (__m512i*)data;
    for (; data_p < (__m512i*)(data + q * sizeof(__m512i)); ++data_p)
    {
        // 每次循环以当前 magickey 生成 16 个连续密钥 k0..k15
        uint32_t ks[16];
        ks[0] = magickey;
        for (int i = 1; i < 16; ++i)
            ks[i] = ks[i - 1] * 7 + 3;
        // 下一轮初始 magickey
        magickey = ks[15] * 7 + 3;

        __m512i v_magickey = _mm512_setr_epi32(
            ks[0], ks[1], ks[2], ks[3],
            ks[4], ks[5], ks[6], ks[7],
            ks[8], ks[9], ks[10], ks[11],
            ks[12], ks[13], ks[14], ks[15]);
        // 加载 64 字节
        __m512i tmp = _mm512_loadu_si512(data_p);
        // 并行异或
        tmp = _mm512_xor_si512(tmp, v_magickey);
        // 写回
        _mm512_storeu_si512(data_p, tmp);
    }
    // 处理剩余 r 字节
    decrypt_file_data_scalar((uint8_t*)data_p, r, magickey);
}
#elif defined(__AVX2__)
static void decrypt_file_data_avx2(uint8_t* data, const size_t n, uint32_t magickey)
{
    const size_t q      = n >> 5;    // 32 字节为一组
    const char   r      = n & MOD_32_MASK;
    __m256i*     data_p = (__m256i*)data;
    for (; data_p < (__m256i*)(data + q * sizeof(__m256i)); ++data_p)
    {
        // 每次循环以当前 magickey 生成 8 个连续密钥 k0..k7
        uint32_t ks[8];
        ks[0] = magickey;
        for (int i = 1; i < 8; ++i)
            ks[i] = ks[i - 1] * 7 + 3;
        // 下一轮初始 magickey
        magickey = ks[7] * 7 + 3;

        __m256i v_magickey = _mm256_setr_epi32(
            ks[0], ks[1], ks[2], ks[3],
            ks[4], ks[5], ks[6], ks[7]);
        // 加载 32 字节
        __m256i tmp = _mm256_loadu_si256(data_p);
        // 并行异或
        tmp = _mm256_xor_si256(tmp, v_magickey);
        // 写回
        _mm256_storeu_si256(data_p, tmp);
    }
    // 处理剩余 r 字节
    decrypt_file_data_scalar((uint8_t*)data_p, r, magickey);
}
#endif

/*
 * 解码数据段
 *
 * @param data 数据段指针
 * @param n 数据段长度
 * @param magickey 解密密钥
 * @return [void]
 */
inline static void decrypt_file_data_dispatch(uint8_t* data, size_t n, uint32_t key)
{
#if defined(__AVX512F__)
    decrypt_file_data_avx512(data, n, key);
#elif defined(__AVX2__)
    decrypt_file_data_avx2(data, n, key);
#else
    decrypt_file_data_scalar(data, n, key);
#endif
}

/*
 * 处理 mkdir 错误
 *
 * @param dir 目录
 * @return [void]
 */
static void mkdir_error_handler(const char* dir)
{
    rb_sys_fail(dir);
}

/*
 * 处理 malloc 错误
 *
 * @return [void]
 */
static void malloc_error_handler(void)
{
    rb_sys_fail("Failed to allocate memory");
}

/*
 * 处理 fopen 错误
 *
 * @param path 文件路径
 * @return [void]
 */
static void fopen_error_handler(const char* path)
{
    rb_sys_fail(path);
}

/*
 * 处理 fseek 错误
 *
 * @param path 文件路径
 * @return [void]
 */
static void fseek_error_handler(const char* path)
{
    rb_sys_fail(path);
}

/*
 * 处理 ftell 错误
 *
 * @param path 文件路径
 * @return [void]
 */
static void ftell_error_handler(const char* path)
{
    rb_sys_fail(path);
}

/*
 * 处理 fread 错误
 *
 * @param path 文件路径
 * @return [void]
 */
static void fread_error_handler(const char* path)
{
    rb_sys_fail(path);
}

/*
 * 处理 fwrite 错误
 *
 * @param path 文件路径
 * @return [void]
 */
static void fwrite_error_handler(const char* path)
{
    rb_sys_fail(path);
}

/*
 * 处理 fclose 错误
 *
 * @param path 文件路径
 * @return [void]
 */
static void fclose_error_handler(const char* path)
{
    rb_sys_fail(path);
}

/*
 * 解码 Game.rgss3a 文件中的 rvdata2 数据
 *
 * @param target_path Game.rgss3a 文件路径
 * @param output_dir 输出目录
 * @param verbose 是否输出详细信息
 * @raise [RGSS3AFileError] 未知的 RGSS3A 文件加密类型
 * @raise [SystemCallError] 系统调用失败
 * @return [void]
 */
static VALUE r3exs_rgss3a_rvdata2(VALUE self, VALUE target_path, VALUE output_dir, const VALUE verbose)
{
    bool verbose_bool = RTEST(verbose);
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
        mkdir_error_handler(output_dir_C);
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
        fopen_error_handler(target_path_C);
#endif

    // 获取文件大小
    if (fseek(Rgss3a_file, 0, SEEK_END) == -1)
    {
#ifdef _WIN32
        free(wchar_arr);
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
        if (fclose(Rgss3a_file) == EOF)
            fclose_error_handler(target_path_C);
        ftell_error_handler(target_path_C);
    }
    if (fseek(Rgss3a_file, 0, SEEK_SET) == -1)
    {
#ifdef _WIN32
        free(wchar_arr);
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
    uint8_t* Rgss3a_p = Rgss3a_data;

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
        // 不支持的 RGSS3A 加密格式
        free(Rgss3a_data);
        const VALUE error_message = rb_sprintf("Unknown RGSS3A file decrypted type: %+" PRIsVALUE, target_path);
        const VALUE exception     = rb_funcall(r3exs_RGSS3AFileError_class, r3exs_new_id, 1, error_message);
        rb_exc_raise(exception);
    }

    // 读取 MagicKey
    Rgss3a_p += 8;
    uint32_t magickey;
    switch (decrypt_type)
    {
        case RGSSAD :
            magickey = *(uint32_t*)Rgss3a_p * 9 + 3;
            break;
        case Fux2Pack2 :
            magickey = *(uint32_t*)Rgss3a_p;
            break;
    }
    Rgss3a_p += 4;

    while (1)
    {
        // 读取数据段偏移量
        uint32_t data_offset = *(uint32_t*)Rgss3a_p ^ magickey;
        if (data_offset == 0)
            break;
        Rgss3a_p += 4;

        // 读取数据段长度
        uint32_t data_size  = *(uint32_t*)Rgss3a_p ^ magickey;
        Rgss3a_p           += 4;

        // 读取数据段 magicKey
        uint32_t data_magickey  = *(uint32_t*)Rgss3a_p ^ magickey;
        Rgss3a_p               += 4;

        // 读取文件名长度
        uint32_t filename_size  = *(uint32_t*)Rgss3a_p ^ magickey;
        Rgss3a_p               += 4;

        // 解码文件名
        if (verbose_bool)
            printf("\e[34mDecrypting DataName...\r");
        decrypt_file_name(Rgss3a_p, filename_size, magickey);

        // 将文件名中的 '\\' 替换为 '/'
        for (uint32_t i = 0; i < filename_size; ++i)
        {
            if (Rgss3a_p[i] == '\\')
                Rgss3a_p[i] = '/';
        }

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
        decrypt_file_data_dispatch(Rgss3a_data + data_offset, data_size, data_magickey);
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
        VALUE output_full_path   = rb_funcall(r3exs_File_module, r3exs_join_id, 2, output_dir, rb_utf8_str_new((char*)Rgss3a_p, filename_size));
        VALUE output_full_dir    = rb_funcall(r3exs_File_module, r3exs_dirname_id, 1, output_full_path);
        char* output_full_path_C = StringValueCStr(output_full_path);
        // 创建目录
        rb_funcall(r3exs_FileUtils_module, r3exs_mkdir_p_id, 1, output_full_dir);

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
 * 初始化 R3EXS 模块
 *
 * @return [void]
 */
void Init_R3EXS()
{
    // 定义 R3EXS 模块
    R3EXS = rb_define_module("R3EXS");
    // 定义 ID
    r3exs_RGSS3AFileError_id = rb_intern("RGSS3AFileError");
    r3exs_File_id            = rb_intern("File");
    r3exs_FileUtils_id       = rb_intern("FileUtils");
    r3exs_Dir_id             = rb_intern("Dir");
    r3exs_join_id            = rb_intern("join");
    r3exs_dirname_id         = rb_intern("dirname");
    r3exs_exist_id           = rb_intern("exist?");
    r3exs_mkdir_p_id         = rb_intern("mkdir_p");

    // 定义模块和类
    r3exs_RGSS3AFileError_class = rb_const_get(R3EXS, r3exs_RGSS3AFileError_id);
    r3exs_File_module           = rb_const_get(rb_cObject, r3exs_File_id);
    r3exs_FileUtils_module      = rb_const_get(rb_cObject, r3exs_FileUtils_id);
    r3exs_Dir_module            = rb_const_get(rb_cObject, r3exs_Dir_id);
    // 定义 rgss3a_rvdata2 方法
    rb_define_singleton_method(R3EXS, "rgss3a_rvdata2", r3exs_rgss3a_rvdata2, 3);
}
