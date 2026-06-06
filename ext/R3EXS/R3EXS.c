#include "ruby.h"
#include <fcntl.h>
#include <immintrin.h>
#include <locale.h>
#ifdef _WIN32
    #include <windows.h>
#endif

static int64_t all_time = 0;

inline static int64_t ns_diff(struct timespec start, struct timespec end)
{
    return (end.tv_sec - start.tv_sec) * 1000000000LL + (end.tv_nsec - start.tv_nsec);
}

#define likely(x)   __builtin_expect(!!(x), 1)
#define unlikely(x) __builtin_expect(!!(x), 0)

#define GREEN_COLOR(str)   "\e[32m" str "\e[0m"    // 绿色
#define MAGENTA_COLOR(str) "\e[35m" str "\e[0m"    // 紫色

VALUE R3EXS = Qnil;

ID r3exs_RGSS3AFileError_id;
ID r3exs_File_id;
ID r3exs_FileUtils_id;
ID r3exs_join_id;
ID r3exs_dirname_id;
ID r3exs_mkdir_p_id;

VALUE r3exs_RGSS3AFileError_class;
VALUE r3exs_File_module;
VALUE r3exs_FileUtils_module;

// 解码文件类型
enum RGSSAD_DECRYPT_TYPE
{
    RGSSAD,
    Fux2Pack2
};

#define MOD_4_MASK 0B11
#define MASK_KEY_1 0X000000FF
#define MASK_KEY_2 0X0000FFFF
#define MASK_KEY_3 0X00FFFFFF

/*
 * 解码文件名
 *
 * @param data [uint8_t*] 文件名指针
 * @param n [uint32_t] 文件名长度
 * @param magickey [uint32_t] 解密密钥
 *
 * @return [void]
 */
static void decrypt_file_name(uint8_t* data, uint32_t n, uint32_t magickey)
{
    uint32_t  q      = n >> 2;
    uint8_t   r      = n & MOD_4_MASK;
    uint32_t* data_p = (uint32_t*)data;
    for (; data_p < (uint32_t*)(data + q * sizeof(uint32_t)); ++data_p)
    {
        *data_p ^= magickey;
    }
    switch (r)
    {
        case 1 : *data_p ^= (magickey & MASK_KEY_1); break;
        case 2 : *data_p ^= (magickey & MASK_KEY_2); break;
        case 3 : *data_p ^= (magickey & MASK_KEY_3); break;
    }
}

static void decrypt_file_data_scalar(uint8_t* data, uint32_t n, uint32_t magickey)
{
    // 主循环：每轮处理 1 块,共 4 字节
    uint32_t* data_p = (uint32_t*)data;
    for (; data_p < (uint32_t*)(data + (n & ~MOD_4_MASK)); ++data_p)
    {
        *data_p  ^= magickey;
        magickey  = magickey * 7 + 3;
    }
    switch (n & MOD_4_MASK)
    {
        case 1 : *data_p ^= (magickey & MASK_KEY_1); break;
        case 2 : *data_p ^= (magickey & MASK_KEY_2); break;
        case 3 : *data_p ^= (magickey & MASK_KEY_3); break;
    }
}

#ifdef __AVX512F__
    #define MOD_64_MASK  0B111111
    #define MOD_256_MASK 0B11111111

static const alignas(64) uint32_t AVX512_MUL_TABLE[16] = {
    1U,             // 7^0 mod 2^32
    7U,             // 7^1 mod 2^32
    49U,            // 7^2 mod 2^32
    343U,           // 7^3 mod 2^32
    2401U,          // 7^4 mod 2^32
    16807U,         // 7^5 mod 2^32
    117649U,        // 7^6 mod 2^32
    823543U,        // 7^7 mod 2^32
    5764801U,       // 7^8 mod 2^32
    40353607U,      // 7^9 mod 2^32
    282475249U,     // 7^10 mod 2^32
    1977326743U,    // 7^11 mod 2^32
    956385313U,     // 7^12 mod 2^32
    2399729895U,    // 7^13 mod 2^32
    3913207377U,    // 7^14 mod 2^32
    1622647863U     // 7^15 mod 2^32
};

static const alignas(64) uint32_t AVX512_ADD_TABLE[16] = {
    0U,             // (7^0-1)/2 mod 2^32
    3U,             // (7^1-1)/2 mod 2^32
    24U,            // (7^2-1)/2 mod 2^32
    171U,           // (7^3-1)/2 mod 2^32
    1200U,          // (7^4-1)/2 mod 2^32
    8403U,          // (7^5-1)/2 mod 2^32
    58824U,         // (7^6-1)/2 mod 2^32
    411771U,        // (7^7-1)/2 mod 2^32
    2882400U,       // (7^8-1)/2 mod 2^32
    20176803U,      // (7^9-1)/2 mod 2^32
    141237624U,     // (7^10-1)/2 mod 2^32
    988663371U,     // (7^11-1)/2 mod 2^32
    2625676304U,    // (7^12-1)/2 mod 2^32
    1199864947U,    // (7^13-1)/2 mod 2^32
    4104087336U,    // (7^14-1)/2 mod 2^32
    2958807579U     // (7^15-1)/2 mod 2^32
};

    #define AVX512_MUL_STEP   2768600449U    // 7^16 mod 2^32
    #define AVX512_ADD_STEP   3531783872U    // (7^16-1)/2 mod 2^32
    #define AVX512_MUL_STEP_4 3233510913U    // 7^64 mod 2^32
    #define AVX512_ADD_STEP_4 1616755456U    // (7^64-1)/2 mod 2^32

static void decrypt_file_data_avx512(uint8_t* data, uint32_t n, uint32_t magickey)
{
    const __m512i v_mul_table = _mm512_load_si512(AVX512_MUL_TABLE);
    const __m512i v_add_table = _mm512_load_si512(AVX512_ADD_TABLE);

    // 4 路循环展开
    const __m512i v_mul_step   = _mm512_set1_epi32(AVX512_MUL_STEP);
    const __m512i v_add_step   = _mm512_set1_epi32(AVX512_ADD_STEP);
    const __m512i v_mul_step_4 = _mm512_set1_epi32(AVX512_MUL_STEP_4);
    const __m512i v_add_step_4 = _mm512_set1_epi32(AVX512_ADD_STEP_4);

    // 4 路独立初始 key
    __m512i v_key0 = _mm512_add_epi32(_mm512_mullo_epi32(_mm512_set1_epi32(magickey), v_mul_table), v_add_table);
    __m512i v_key1 = _mm512_add_epi32(_mm512_mullo_epi32(v_key0, v_mul_step), v_add_step);
    __m512i v_key2 = _mm512_add_epi32(_mm512_mullo_epi32(v_key1, v_mul_step), v_add_step);
    __m512i v_key3 = _mm512_add_epi32(_mm512_mullo_epi32(v_key2, v_mul_step), v_add_step);

    // 主循环：每轮处理 4 块,共 256 字节
    __m512i* v_data_p = (__m512i*)data;
    for (; v_data_p < (__m512i*)(data + (n & ~MOD_256_MASK)); v_data_p += 4)
    {
        _mm512_storeu_si512(v_data_p + 0, _mm512_xor_si512(_mm512_loadu_si512(v_data_p + 0), v_key0));
        _mm512_storeu_si512(v_data_p + 1, _mm512_xor_si512(_mm512_loadu_si512(v_data_p + 1), v_key1));
        _mm512_storeu_si512(v_data_p + 2, _mm512_xor_si512(_mm512_loadu_si512(v_data_p + 2), v_key2));
        _mm512_storeu_si512(v_data_p + 3, _mm512_xor_si512(_mm512_loadu_si512(v_data_p + 3), v_key3));
        v_key0 = _mm512_add_epi32(_mm512_mullo_epi32(v_key0, v_mul_step_4), v_add_step_4);
        v_key1 = _mm512_add_epi32(_mm512_mullo_epi32(v_key1, v_mul_step_4), v_add_step_4);
        v_key2 = _mm512_add_epi32(_mm512_mullo_epi32(v_key2, v_mul_step_4), v_add_step_4);
        v_key3 = _mm512_add_epi32(_mm512_mullo_epi32(v_key3, v_mul_step_4), v_add_step_4);
    }

    decrypt_file_data_scalar((uint8_t*)v_data_p, n & MOD_256_MASK, _mm512_cvtsi512_si32(v_key0));
}
#elifdef __AVX2__
    #define MOD_128_MASK 0B1111111

static const alignas(32) uint32_t AVX2_MUL_TABLE[8] = {
    1U,         // 7^0 mod 2^32
    7U,         // 7^1 mod 2^32
    49U,        // 7^2 mod 2^32
    343U,       // 7^3 mod 2^32
    2401U,      // 7^4 mod 2^32
    16807U,     // 7^5 mod 2^32
    117649U,    // 7^6 mod 2^32
    823543U,    // 7^7 mod 2^32
};

static const alignas(32) uint32_t AVX2_ADD_TABLE[8] = {
    0U,         // (7^0-1)/2 mod 2^32
    3U,         // (7^1-1)/2 mod 2^32
    24U,        // (7^2-1)/2 mod 2^32
    171U,       // (7^3-1)/2 mod 2^32
    1200U,      // (7^4-1)/2 mod 2^32
    8403U,      // (7^5-1)/2 mod 2^32
    58824U,     // (7^6-1)/2 mod 2^32
    411771U,    // (7^7-1)/2 mod 2^32
};

    #define AVX2_MUL_STEP   5764801U       // 7^8 mod 2^32
    #define AVX2_ADD_STEP   2882400U       // (7^8-1)/2 mod 2^32
    #define AVX2_MUL_STEP_4 1855011585U    // 7^32 mod 2^32
    #define AVX2_ADD_STEP_4 927505792U     // (7^32-1)/2 mod 2^32

static void decrypt_file_data_avx2(uint8_t* data, uint32_t n, uint32_t magickey)
{
    const __m256i v_mul_table = _mm256_load_si256((__m256i*)AVX2_MUL_TABLE);
    const __m256i v_add_table = _mm256_load_si256((__m256i*)AVX2_ADD_TABLE);

    // 4 路循环展开
    const __m256i v_mul_step   = _mm256_set1_epi32(AVX2_MUL_STEP);
    const __m256i v_add_step   = _mm256_set1_epi32(AVX2_ADD_STEP);
    const __m256i v_mul_step_4 = _mm256_set1_epi32(AVX2_MUL_STEP_4);
    const __m256i v_add_step_4 = _mm256_set1_epi32(AVX2_ADD_STEP_4);

    // 4 路独立初始 key
    __m256i v_key0 = _mm256_add_epi32(_mm256_mullo_epi32(_mm256_set1_epi32(magickey), v_mul_table), v_add_table);
    __m256i v_key1 = _mm256_add_epi32(_mm256_mullo_epi32(v_key0, v_mul_step), v_add_step);
    __m256i v_key2 = _mm256_add_epi32(_mm256_mullo_epi32(v_key1, v_mul_step), v_add_step);
    __m256i v_key3 = _mm256_add_epi32(_mm256_mullo_epi32(v_key2, v_mul_step), v_add_step);

    // 主循环：每轮处理 4 块,共 128 字节
    __m256i* v_data_p = (__m256i*)data;
    for (; v_data_p < (__m256i*)(data + (n & ~MOD_128_MASK)); v_data_p += 4)
    {
        _mm256_storeu_si256(v_data_p + 0, _mm256_xor_si256(_mm256_loadu_si256(v_data_p + 0), v_key0));
        _mm256_storeu_si256(v_data_p + 1, _mm256_xor_si256(_mm256_loadu_si256(v_data_p + 1), v_key1));
        _mm256_storeu_si256(v_data_p + 2, _mm256_xor_si256(_mm256_loadu_si256(v_data_p + 2), v_key2));
        _mm256_storeu_si256(v_data_p + 3, _mm256_xor_si256(_mm256_loadu_si256(v_data_p + 3), v_key3));
        v_key0 = _mm256_add_epi32(_mm256_mullo_epi32(v_key0, v_mul_step_4), v_add_step_4);
        v_key1 = _mm256_add_epi32(_mm256_mullo_epi32(v_key1, v_mul_step_4), v_add_step_4);
        v_key2 = _mm256_add_epi32(_mm256_mullo_epi32(v_key2, v_mul_step_4), v_add_step_4);
        v_key3 = _mm256_add_epi32(_mm256_mullo_epi32(v_key3, v_mul_step_4), v_add_step_4);
    }

    decrypt_file_data_scalar((uint8_t*)v_data_p, n & MOD_128_MASK, _mm256_cvtsi256_si32(v_key0));
}
#endif

/*
 * 解码数据段
 *
 * @param data [uint8_t*] 数据段指针
 * @param n [uint32_t] 数据段长度
 * @param magickey [uint32_t] 解密密钥
 *
 * @return [void]
 */
inline static void decrypt_file_data_dispatch(uint8_t* data, uint32_t n, uint32_t key)
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
static VALUE r3exs_rgss3a_rvdata2(VALUE self, VALUE target_path, VALUE output_dir, VALUE verbose)
{
    bool verbose_bool = RB_TEST(verbose);
    // 首先将 Ruby 的 RString 转换为 C 字符串
    const char* const target_path_c = RSTRING_PTR(target_path);

    // 获取文件描述符
    int fd = open(
        target_path_c,
        O_RDONLY
#ifdef __WIN32
            | O_BINARY    // Windows 下以二进制模式打开文件
#endif
    );
    if (unlikely(fd == -1))
    {
        rb_sys_fail(target_path_c);
    }

    // 获取文件大小
    struct stat st;
    if (unlikely(fstat(fd, &st) == -1))
    {
        close(fd);
        rb_sys_fail(target_path_c);
    }
    off_t rgss3a_file_size = st.st_size;

    // 使用 read 读取整个文件到内存
    uint8_t* rgss3a_data = (uint8_t*)malloc(sizeof(uint8_t) * rgss3a_file_size);
#ifdef __linux__
    posix_fadvise(fd, 0, 0, POSIX_FADV_SEQUENTIAL);    // 可选，加速预读
#endif
    ssize_t n = read(fd, rgss3a_data, rgss3a_file_size);
    if (unlikely(n == -1 || n < rgss3a_file_size))
    {
        free(rgss3a_data);
        close(fd);
        rb_sys_fail(target_path_c);
    }

    // 关闭文件描述符
    close(fd);
    if (unlikely(verbose_bool))
    {
        printf(GREEN_COLOR("Readed:") "%s\n", target_path_c);
    }

    // 设置文件指针索引
    uint8_t* rgss3a_p = rgss3a_data;

    // 判断加密类型
    enum RGSSAD_DECRYPT_TYPE decrypt_type;
    if (likely(memcmp(rgss3a_p, "RGSSAD\x00\x03", 8) == 0))
    {
        decrypt_type = RGSSAD;
    }
    else if (memcmp(rgss3a_p, "Fux2Pack", 8) == 0)
    {
        decrypt_type = Fux2Pack2;
    }
    else
    {
        // 不支持的 RGSS3A 加密格式
        free(rgss3a_data);
        rb_raise(r3exs_RGSS3AFileError_class, "Unknown RGSS3A file decrypted type: %+" PRIsVALUE, target_path);
    }
    rgss3a_p += 8;

    // 读取 MagicKey
    uint32_t magickey;
    switch (decrypt_type)
    {
        case RGSSAD    : magickey = *(uint32_t*)rgss3a_p * 9 + 3; break;
        case Fux2Pack2 : magickey = *(uint32_t*)rgss3a_p; break;
    }
    rgss3a_p += 4;

    struct timespec start;
    struct timespec end;
    while (true)
    {
        // 读取数据段偏移量
        uint32_t data_offset = *(uint32_t*)rgss3a_p ^ magickey;
        if (unlikely(data_offset == 0))
        {
            break;
        }
        rgss3a_p += 4;

        // 读取数据段长度
        uint32_t data_size  = *(uint32_t*)rgss3a_p ^ magickey;
        rgss3a_p           += 4;

        // 读取数据段 magicKey
        uint32_t data_magickey  = *(uint32_t*)rgss3a_p ^ magickey;
        rgss3a_p               += 4;

        // 读取文件名长度
        uint32_t filename_size  = *(uint32_t*)rgss3a_p ^ magickey;
        rgss3a_p               += 4;

        // 解码文件名
        decrypt_file_name(rgss3a_p, filename_size, magickey);
        // 将文件名中的 '\\' 替换为 '/'
        for (uint32_t i = 0; i < filename_size; ++i)
        {
            if (unlikely(rgss3a_p[i] == '\\'))
            {
                rgss3a_p[i] = '/';
            }
        }

        // 解码数据段
        decrypt_file_data_dispatch(rgss3a_data + data_offset, data_size, data_magickey);
        if (unlikely(verbose_bool))
        {
            printf(
                GREEN_COLOR("Decrypted:") "%.*s " GREEN_COLOR("Offset:") MAGENTA_COLOR("%u ") GREEN_COLOR("Size:")
                    MAGENTA_COLOR("%u ") GREEN_COLOR("MagicKey:") MAGENTA_COLOR("%u\n"),
                filename_size,
                rgss3a_p,
                data_offset,
                data_size,
                data_magickey
            );
        }

        // 写入解密后的数据到文件
        // 先将 output_dir 和文件名拼接得到 output_full_path
        // 再通过 File.dirname(output_full_path) 获得 output_full_dir
        // 最后通过 FileUtils.mkdir_p(output_full_dir) 递归创建目录
        VALUE output_full_path = rb_funcall(
            r3exs_File_module, r3exs_join_id, 2, output_dir, rb_utf8_str_new((char*)rgss3a_p, filename_size)
        );
        VALUE             output_full_dir    = rb_funcall(r3exs_File_module, r3exs_dirname_id, 1, output_full_path);
        const char* const output_full_path_c = StringValueCStr(output_full_path);
        // 递归创建目录
        rb_funcall(r3exs_FileUtils_module, r3exs_mkdir_p_id, 1, output_full_dir);

        // 写入文件
        clock_gettime(CLOCK_MONOTONIC_RAW, &start);
        FILE* output_file = fopen(output_full_path_c, "wb");
        if (unlikely(!output_file))
        {
            free(rgss3a_data);
            rb_sys_fail(output_full_path_c);
        }
        size_t n = fwrite(rgss3a_data + data_offset, sizeof(uint8_t), data_size, output_file);
        if (unlikely(n < data_size))
        {
            free(rgss3a_data);
            fclose(output_file);
            rb_sys_fail(output_full_path_c);
        }
        if (unlikely(fclose(output_file) == EOF))
        {
            rb_sys_fail(output_full_path_c);
        }
        if (unlikely(verbose_bool))
        {
            printf(GREEN_COLOR("Writed:") "%s\n", output_full_path_c);
        }
        clock_gettime(CLOCK_MONOTONIC_RAW, &end);
        all_time += ns_diff(start, end);

        rgss3a_p += filename_size;
    }

    free(rgss3a_data);

    printf(GREEN_COLOR("Total Time_ms:") "%f\n", (double)all_time / 1000000);
    return Qnil;
}

/*
 * 初始化 R3EXS 模块
 *
 * @return [void]
 */
void Init_R3EXS()
{
#ifdef _WIN32
    setlocale(LC_ALL, ".utf-8");    // 设置标准库调用系统 API 所用的编码
#endif

    // 定义 R3EXS 模块
    R3EXS = rb_define_module("R3EXS");
    // 定义 ID
    r3exs_RGSS3AFileError_id = rb_intern("RGSS3AFileError");
    r3exs_File_id            = rb_intern("File");
    r3exs_FileUtils_id       = rb_intern("FileUtils");
    r3exs_join_id            = rb_intern("join");
    r3exs_dirname_id         = rb_intern("dirname");
    r3exs_mkdir_p_id         = rb_intern("mkdir_p");

    // 定义模块和类
    r3exs_RGSS3AFileError_class = rb_const_get(R3EXS, r3exs_RGSS3AFileError_id);
    r3exs_File_module           = rb_const_get(rb_cObject, r3exs_File_id);
    r3exs_FileUtils_module      = rb_const_get(rb_cObject, r3exs_FileUtils_id);
    // 定义 rgss3a_rvdata2 方法
    rb_define_singleton_method(R3EXS, "rgss3a_rvdata2", r3exs_rgss3a_rvdata2, 3);
}
