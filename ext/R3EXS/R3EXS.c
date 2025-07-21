#include <fcntl.h>
#include "ruby.h"

#define likely(x)   __builtin_expect(!!(x), 1)
#define unlikely(x) __builtin_expect(!!(x), 0)

#ifdef _WIN32
wchar_t*       filename_arr = NULL;
unsigned short filename_len = 0;

/*
 * 将指定长度的 UTF-8 字符串转换为 wchar 字符串
 * wchar 字符串会被存储在 filename_arr 中
 * 同时更新 filename_len
 *
 * @param utf8char [const char*] UTF-8 字符串
 * @param n [size_t] 字符串长度
 *
 * @return [int] 0 成功，-1 失败
 */
static int utf8towc(const char* utf8char, size_t n)
{
    // 计算转换为 wchar 所需的缓冲区大小，包括结尾的 '\0'
    int wc_size = MultiByteToWideChar(CP_UTF8, 0, utf8char, n, NULL, 0) + 1;
    if (unlikely(wc_size == 1))    // 转换失败
    {
        if (GetLastError() == ERROR_NO_UNICODE_TRANSLATION)
        {
            errno = EILSEQ;
            return -1;
        }
    }
    if (wc_size > filename_len)
    {
        wchar_t* wchar_arr_new = (wchar_t*)realloc(filename_arr, sizeof(wchar_t) * wc_size);
        if (unlikely(!wchar_arr_new))
        {
            errno = ENOMEM;
            return -1;
        }
        filename_arr = wchar_arr_new;
        filename_len = wc_size;
    }

    // 执行从 UTF-8 到 wchar 的转换
    MultiByteToWideChar(CP_UTF8, 0, utf8char, n, filename_arr, filename_len);
    // 添加结尾的 '\0'
    filename_arr[wc_size - 1] = L'\0';
    return 0;
}
#endif

#ifdef __linux__
    #include <sys/mman.h>
char*          filename_arr = NULL;
unsigned short filename_len = 0;

/*
 * 将指定长度的 UTF-8 字符串 转换为 char 字符串
 * char 字符串会被存储在 char_arr 中
 * 同时更新 char_arr_size
 *
 * @param utf8char [char*] UTF-8 字符串
 * @param n [size_t] 字符串长度
 *
 * @return 0 成功，-1 失败
 */
static int utf8tomb(const char* utf8char, const size_t n)
{
    // 计算转换为 char 所需的缓冲区大小，包括结尾的 '\0'
    const size_t mb_size = n + 1;
    if (mb_size > filename_len)
    {
        char* char_arr_new = (char*)realloc(filename_arr, sizeof(char) * mb_size);
        if (unlikely(!char_arr_new))
        {
            errno = ENOMEM;
            return -1;
        }
        filename_arr = char_arr_new;
        filename_len = mb_size;
    }
    // 注意此处不能使用 strcpy
    // 因为 utf8char 不是 '\0' 结尾字符串
    memcpy(filename_arr, utf8char, n);
    filename_arr[mb_size - 1] = '\0';
    return 0;
}
#endif

VALUE R3EXS = Qnil;

ID r3exs_RGSS3AFileError_id;
ID r3exs_File_id;
ID r3exs_FileUtils_id;
ID r3exs_Dir_id;
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

#ifdef __AVX512F__
    #include <immintrin.h>
    #define MOD_64_MASK 0b111111
#elifdef __AVX2__
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
 * @param data [uint8_t*] 文件名指针
 * @param n [size_t] 文件名长度
 * @param magickey [uint32_t] 解密密钥
 *
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

#ifdef __AVX512F__
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
#elifdef __AVX2__
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
 * @param data [uint8_t*] 数据段指针
 * @param n [size_t] 数据段长度
 * @param magickey [uint32_t] 解密密钥
 *
 * @return [void]
 */
inline static void decrypt_file_data_dispatch(uint8_t* data, size_t n, uint32_t key)
{
#ifdef __AVX512F__
    decrypt_file_data_avx512(data, n, key);
#elifdef __AVX2__
    decrypt_file_data_avx2(data, n, key);
#else
    decrypt_file_data_scalar(data, n, key);
#endif
}

/*
 * 释放 mmap 创建的内存映射
 *
 * @param addr [void*] 内存映射的地址
 * @param len [size_t] 内存映射的大小
 *
 * @return [int] 0 munmap成功, -1 munmap失败
 */
inline static int munmap_wrapper(void* addr, size_t len)
{
#ifdef _WIN32
    return UnmapViewOfFile(addr) ? 0 : -1;
#elif defined(__linux__)
    return munmap(addr, len);
#endif
}

/* 创建 mmap 内存映射
 *
 * @param fd [int] 文件描述符
 * @param len [size_t] 内存映射的大小
 *
 * @return [void*] MAP_FAILED 失败
 */
inline static void* mmap_wapper(int fd, size_t len)
{
#ifdef _WIN32
    HANDLE hFile = (HANDLE)_get_osfhandle(fd);
    if (unlikely(hFile == INVALID_HANDLE_VALUE)) return MAP_FAILED;

    HANDLE hMap = CreateFileMappingW(hFile, NULL, PAGE_WRITECOPY, 0, 0, NULL);
    if (unlikely(!hMap)) return MAP_FAILED;

    void* mapped = MapViewOfFile(hMap, FILE_MAP_COPY, 0, 0, 0);
    CloseHandle(hMap);

    return likely(mapped) ? mapped : MAP_FAILED;
#elifdef __linux__
    return mmap(NULL, len, PROT_READ | PROT_WRITE, MAP_PRIVATE, fd, 0);
#endif
}

/*
 * 获取文件描述符
 *
 * @param dir [const char*] UTF-8 字符串文件路径
 *
 * @return [int] -1 open失败, -2 utf8towc失败
 */
inline static int open_wapper(const char* dir)
{
#ifdef _WIN32
    if (unlikely(utf8towc(dir, strlen(dir)) == -1))
        return -2;
    return _wopen(filename_arr, O_RDONLY | O_BINARY);
#elifdef __linux__
    return open(dir, O_RDONLY);
#endif
}

/*
 * 创建文件夹
 *
 * @param dir UTF-8 字符串文件路径
 *
 * @return [int] -1 mkdir失败, -2 utf8towc失败
 */
inline static int mkdir_wapper(const char* dir)
{
#ifdef _WIN32
    if (unlikely(utf8towc(dir, strlen(dir)) == -1))
        return -2;
    return _wmkdir(filename_arr);
#elifdef __linux__
    return mkdir(dir, 0755);
#endif
}

/*
 * 解码 Game.rgss3a 文件中的 rvdata2 数据
 *
 * @param target_path Game.rgss3a 文件路径
 * @param output_dir 输出目录
 * @param verbose 是否输出详细信息
 * @raise [RGSS3AFileError] 未知的 RGSS3A 文件加密类型
 * @raise [SystemCallError] 系统调用失败
 *
 * @return [void]
 */
static VALUE r3exs_rgss3a_rvdata2(VALUE self, VALUE target_path, VALUE output_dir, const VALUE verbose)
{
    bool verbose_bool = RTEST(verbose);
    // 首先将 Ruby 的 VALUE 转换为 C 的字符串
    char* target_path_C = StringValueCStr(target_path);
    char* output_dir_C  = StringValueCStr(output_dir);

    // 创建 output_dir
    int result = mkdir_wapper(output_dir_C);
#ifdef _WIN32
    if (unlikely(result == -2))
    {
        free(filename_arr);
        rb_sys_fail("Failed to convert UTF-8 to wchar");
    }
    if (unlikely(result == -1 && errno != EEXIST))
    {
        free(filename_arr);
        rb_sys_fail(output_dir_C);
    }
#elifdef __linux__
    if (unlikely(result == -1 && errno != EEXIST))
        rb_sys_fail(output_dir_C);
#endif

    // 获取文件描述符
    int fd = open_wapper(target_path_C);
#ifdef _WIN32
    if (unlikely(fd == -2))
    {
        free(filename_arr);
        rb_sys_fail("Failed to convert UTF-8 to wchar");
    }
    if (unlikely(fd == -1))
    {
        free(filename_arr);
        rb_sys_fail(target_path_C);
    }
#elifdef __linux__
    if (unlikely(fd == -1))
        rb_sys_fail(target_path_C);
#endif

    // 获取文件大小
    struct stat sb;
    if (unlikely(fstat(fd, &sb) == -1))
    {
#ifdef _WIN32
        free(filename_arr);
#endif
        close(fd);
        rb_sys_fail(target_path_C);
    }
    off_t Rgss3a_file_size = sb.st_size;

    // 使用 mmap 映射文件
    uint8_t* Rgss3a_data = mmap_wapper(fd, Rgss3a_file_size);
    if (unlikely(Rgss3a_data == MAP_FAILED))
    {
#ifdef _WIN32
        free(filename_arr);
#endif
        close(fd);
        rb_sys_fail("Failed to mmap file");
    }

    // 关闭文件描述符
    close(fd);
#ifdef _WIN32
    if (unlikely(verbose_bool))
        printf("\e[2K\e[32mMmapped \e[0m%ls\n", filename_arr);
#elifdef __linux__
    if (unlikely(verbose_bool))
        printf("\e[2K\e[32mMmapped \e[0m%s\n", target_path_C);
#endif

    // 设置文件指针索引
    uint8_t* Rgss3a_p = Rgss3a_data;

    // 判断加密类型
    enum RGSSAD_DECRYPT_TYPE decrypt_type;
    if (likely(memcmp(Rgss3a_p, "RGSSAD\x00\x03", 8) == 0))
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
        free(filename_arr);
#endif
        // 不支持的 RGSS3A 加密格式
        munmap_wrapper(Rgss3a_data, Rgss3a_file_size);
        rb_raise(r3exs_RGSS3AFileError_class, "Unknown RGSS3A file decrypted type: %+" PRIsVALUE, target_path);
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

    while (true)
    {
        // 读取数据段偏移量
        uint32_t data_offset = *(uint32_t*)Rgss3a_p ^ magickey;
        if (unlikely(data_offset == 0))
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
        if (unlikely(verbose_bool))
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
        if (unlikely(utf8towc((char*)Rgss3a_p, filename_size) == -1))
#elifdef __linux__
        if (unlikely(utf8tomb((char*)Rgss3a_p, filename_size) == -1))
#endif
        {
            free(filename_arr);
            munmap_wrapper(Rgss3a_data, Rgss3a_file_size);
#ifdef _WIN32
            rb_sys_fail("Failed to convert UTF-8 to wchar");
#elifdef __linux__
            rb_sys_fail("Failed to convert UTF-8 to char");
#endif
        }

        // 解码数据段
#ifdef _WIN32
        if (unlikely(verbose_bool))
            printf("\e[2K\e[32mDecrypting \e[0m%ls \e[0mOffset: \e[35m%u \e[0mSize: \e[35m%u \e[0mMagicKey: \e[35m%u\e[0m...\r", filename_arr, data_offset, data_size, data_magickey);
#elifdef __linux__
        if (unlikely(verbose_bool))
            printf("\e[2K\e[32mDecrypting \e[0m%s \e[0mOffset: \e[35m%u \e[0mSize: \e[35m%u \e[0mMagicKey: \e[35m%u\e[0m...\r", filename_arr, data_offset, data_size, data_magickey);
#endif
        decrypt_file_data_dispatch(Rgss3a_data + data_offset, data_size, data_magickey);
#ifdef _WIN32
        if (unlikely(verbose_bool))
            printf("\e[2K\e[32mDecrypted \e[0m%ls \e[0mOffset: \e[35m%u \e[0mSize: \e[35m%u \e[0mMagicKey: \e[35m%u\e[0m\n", filename_arr, data_offset, data_size, data_magickey);
#elifdef __linux__
        if (unlikely(verbose_bool))
            printf("\e[2K\e[32mDecrypted \e[0m%s \e[0mOffset: \e[35m%u \e[0mSize: \e[35m%u \e[0mMagicKey: \e[35m%u\e[0m\n", filename_arr, data_offset, data_size, data_magickey);
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
        if (unlikely(utf8towc(output_full_path_C, strlen(output_full_path_C)) == -1))
        {
            free(filename_arr);
            munmap_wrapper(Rgss3a_data, Rgss3a_file_size);
            rb_sys_fail("Failed to convert UTF-8 to wchar");
        }
        if (unlikely(verbose_bool))
            printf("\e[34mWriting \e[0m%ls...\r", filename_arr);
        FILE* output_file = _wfopen(filename_arr, L"wb");
#elifdef __linux__
        if (unlikely(verbose_bool))
            printf("\e[34mWriting \e[0m%s...\r", output_full_path_C);
        FILE* output_file = fopen(output_full_path_C, "wb");
#endif
        if (unlikely(!output_file))
        {
            free(filename_arr);
            munmap_wrapper(Rgss3a_data, Rgss3a_file_size);
            rb_sys_fail(output_full_path_C);
        }

        // 写入文件
        size_t result = fwrite(Rgss3a_data + data_offset, sizeof(uint8_t), data_size, output_file);
        if (unlikely(result < data_size))
        {
            free(filename_arr);
            munmap_wrapper(Rgss3a_data, Rgss3a_file_size);
            fclose(output_file);
            rb_sys_fail(output_full_path_C);
        }
        if (unlikely(fclose(output_file) == EOF))
            rb_sys_fail(output_full_path_C);
        if (unlikely(verbose_bool))
#ifdef _WIN32
            printf("\e[2K\e[32mWrited \e[0m%ls\n", filename_arr);
#elifdef __linux__
            printf("\e[2K\e[32mWrited \e[0m%s\n", output_full_path_C);
#endif
        Rgss3a_p += filename_size;
    }

    free(filename_arr);
    munmap_wrapper(Rgss3a_data, Rgss3a_file_size);
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