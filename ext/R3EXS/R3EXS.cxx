#include "ruby.h"
#include <algorithm>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <immintrin.h>
#include <memory>
#include <print>
#include <span>
#include <unordered_set>
#include <vector>
#ifdef _WIN32
    #include <clocale>
    #include <windows.h>
#endif

#define GREEN_COLOR(str)   "\e[32m" str "\e[0m"    // 绿色
#define MAGENTA_COLOR(str) "\e[35m" str "\e[0m"    // 紫色

namespace
{

// 加密文件头部常量
constexpr std::uint64_t RGSSAD_HEADER {0X0300444153534752};       // "RGSSAD\0\3"
constexpr std::uint64_t FUX2PACK2_HEADER {0X6B63615032787546};    // "Fux2Pack"

constexpr std::uint32_t MOD_4_MASK {0B11};

struct DecryptTask
{
    std::span<char>       filename;
    std::uint32_t         filename_magickey;
    std::span<char>       data;
    std::uint32_t         data_magickey;
    std::filesystem::path output_full_path;
};

class RGSS3AFileError: public std::runtime_error
{
public:
    explicit RGSS3AFileError(const std::string& message): std::runtime_error(message)
    {}
};

template <class T>
requires std::is_trivially_copyable_v<T>
[[nodiscard]]
inline T load_little_data(char*& data) noexcept
{
    T t;
    std::memcpy(&t, data, sizeof(T));
    data += sizeof(T);
    return t;
}

inline void xor_u32(char* data, std::uint32_t key) noexcept
{
    std::uint32_t value {};
    std::memcpy(&value, data, sizeof(value));
    value ^= key;
    std::memcpy(data, &value, sizeof(value));
}

void decrypt_file_name(std::span<char> data, std::uint32_t magickey) noexcept
{
    // 主循环：每轮处理 1 块,共 4 字节
    auto  n {data.size()};
    auto* data_p {data.data()};
    for (; data_p < data.data() + (n & ~MOD_4_MASK); data_p += 4)
    {
        xor_u32(data_p, magickey);
    }

    auto key_array {std::bit_cast<std::array<char, 4>>(magickey)};
    switch (n & MOD_4_MASK)
    {
        case 3 : data_p[2] ^= key_array[2]; [[fallthrough]];
        case 2 : data_p[1] ^= key_array[1]; [[fallthrough]];
        case 1 : data_p[0] ^= key_array[0];
    }
}

void decrypt_file_data_scalar(std::span<char> data, std::uint32_t magickey) noexcept
{
    // 主循环：每轮处理 1 块,共 4 字节
    auto  n {data.size()};
    auto* data_p {data.data()};
    for (; data_p < data.data() + (n & ~MOD_4_MASK); data_p += 4)
    {
        xor_u32(data_p, magickey);
        magickey = (magickey * 7) + 3;
    }

    auto key_array {std::bit_cast<std::array<char, 4>>(magickey)};
    switch (n & MOD_4_MASK)
    {
        case 3 : data_p[2] ^= key_array[2]; [[fallthrough]];
        case 2 : data_p[1] ^= key_array[1]; [[fallthrough]];
        case 1 : data_p[0] ^= key_array[0];
    }
}

#ifdef __AVX512F__
constexpr std::uint32_t MOD_256_MASK {0B11111111};

alignas(64) constexpr std::array<std::uint32_t, 16> AVX512_MUL_TABLE {
    1U,                                                     // 7^0 mod 2^32
    7U,                                                     // 7^1 mod 2^32
    49U,                                                    // 7^2 mod 2^32
    343U,                                                   // 7^3 mod 2^32
    2401U,                                                  // 7^4 mod 2^32
    16807U,                                                 // 7^5 mod 2^32
    117649U,                                                // 7^6 mod 2^32
    823543U,                                                // 7^7 mod 2^32
    5764801U,                                               // 7^8 mod 2^32
    40353607U,                                              // 7^9 mod 2^32
    282475249U,                                             // 7^10 mod 2^32
    1977326743U,                                            // 7^11 mod 2^32
    956385313U,                                             // 7^12 mod 2^32
    2399729895U,                                            // 7^13 mod 2^32
    3913207377U,                                            // 7^14 mod 2^32
    1622647863U                                             // 7^15 mod 2^32
};
constexpr std::uint32_t AVX512_MUL_STEP {2768600449U};      // 7^16 mod 2^32
constexpr std::uint32_t AVX512_MUL_STEP_4 {3233510913U};    // 7^64 mod 2^32

alignas(64) constexpr std::array<std::uint32_t, 16> AVX512_ADD_TABLE {
    0U,                                                     // (7^0-1)/2 mod 2^32
    3U,                                                     // (7^1-1)/2 mod 2^32
    24U,                                                    // (7^2-1)/2 mod 2^32
    171U,                                                   // (7^3-1)/2 mod 2^32
    1200U,                                                  // (7^4-1)/2 mod 2^32
    8403U,                                                  // (7^5-1)/2 mod 2^32
    58824U,                                                 // (7^6-1)/2 mod 2^32
    411771U,                                                // (7^7-1)/2 mod 2^32
    2882400U,                                               // (7^8-1)/2 mod 2^32
    20176803U,                                              // (7^9-1)/2 mod 2^32
    141237624U,                                             // (7^10-1)/2 mod 2^32
    988663371U,                                             // (7^11-1)/2 mod 2^32
    2625676304U,                                            // (7^12-1)/2 mod 2^32
    1199864947U,                                            // (7^13-1)/2 mod 2^32
    4104087336U,                                            // (7^14-1)/2 mod 2^32
    2958807579U                                             // (7^15-1)/2 mod 2^32
};
constexpr std::uint32_t AVX512_ADD_STEP {3531783872U};      // (7^16-1)/2 mod 2^32
constexpr std::uint32_t AVX512_ADD_STEP_4 {1616755456U};    // (7^64-1)/2 mod 2^32

void decrypt_file_data_avx512(std::span<char> data, std::uint32_t magickey) noexcept
{
    auto v_mul_table {_mm512_load_si512(AVX512_MUL_TABLE.data())};
    auto v_add_table {_mm512_load_si512(AVX512_ADD_TABLE.data())};

    // 4 路循环展开
    auto v_mul_step {_mm512_set1_epi32(AVX512_MUL_STEP)};
    auto v_add_step {_mm512_set1_epi32(AVX512_ADD_STEP)};
    auto v_mul_step_4 {_mm512_set1_epi32(AVX512_MUL_STEP_4)};
    auto v_add_step_4 {_mm512_set1_epi32(AVX512_ADD_STEP_4)};

    // 4 路独立初始 key
    auto v_key0 {_mm512_add_epi32(_mm512_mullo_epi32(_mm512_set1_epi32(magickey), v_mul_table), v_add_table)};
    auto v_key1 {_mm512_add_epi32(_mm512_mullo_epi32(v_key0, v_mul_step), v_add_step)};
    auto v_key2 {_mm512_add_epi32(_mm512_mullo_epi32(v_key1, v_mul_step), v_add_step)};
    auto v_key3 {_mm512_add_epi32(_mm512_mullo_epi32(v_key2, v_mul_step), v_add_step)};

    // 主循环：每轮处理 4 块,共 256 字节
    auto  n {data.size()};
    auto* data_p {data.data()};
    for (; data_p < data.data() + (n & ~MOD_256_MASK); data_p += 256)
    {
        _mm512_storeu_si512(data_p + 0, _mm512_xor_si512(_mm512_loadu_si512(data_p + 0), v_key0));
        _mm512_storeu_si512(data_p + 64, _mm512_xor_si512(_mm512_loadu_si512(data_p + 64), v_key1));
        _mm512_storeu_si512(data_p + 128, _mm512_xor_si512(_mm512_loadu_si512(data_p + 128), v_key2));
        _mm512_storeu_si512(data_p + 192, _mm512_xor_si512(_mm512_loadu_si512(data_p + 192), v_key3));
        v_key0 = _mm512_add_epi32(_mm512_mullo_epi32(v_key0, v_mul_step_4), v_add_step_4);
        v_key1 = _mm512_add_epi32(_mm512_mullo_epi32(v_key1, v_mul_step_4), v_add_step_4);
        v_key2 = _mm512_add_epi32(_mm512_mullo_epi32(v_key2, v_mul_step_4), v_add_step_4);
        v_key3 = _mm512_add_epi32(_mm512_mullo_epi32(v_key3, v_mul_step_4), v_add_step_4);
    }

    decrypt_file_data_scalar(data.subspan(data.size() - (n & MOD_256_MASK)), _mm512_cvtsi512_si32(v_key0));
}
#elifdef __AVX2__
constexpr std::uint32_t MOD_128_MASK {0B1111111};

alignas(32) constexpr std::array<std::uint32_t, 8> AVX2_MUL_TABLE {
    1U,                                                   // 7^0 mod 2^32
    7U,                                                   // 7^1 mod 2^32
    49U,                                                  // 7^2 mod 2^32
    343U,                                                 // 7^3 mod 2^32
    2401U,                                                // 7^4 mod 2^32
    16807U,                                               // 7^5 mod 2^32
    117649U,                                              // 7^6 mod 2^32
    823543U,                                              // 7^7 mod 2^32
};
constexpr std::uint32_t AVX2_MUL_STEP {5764801U};         // 7^8 mod 2^32
constexpr std::uint32_t AVX2_MUL_STEP_4 {1855011585U};    // 7^32 mod 2^32

alignas(32) constexpr std::array<std::uint32_t, 8> AVX2_ADD_TABLE {
    0U,                                                  // (7^0-1)/2 mod 2^32
    3U,                                                  // (7^1-1)/2 mod 2^32
    24U,                                                 // (7^2-1)/2 mod 2^32
    171U,                                                // (7^3-1)/2 mod 2^32
    1200U,                                               // (7^4-1)/2 mod 2^32
    8403U,                                               // (7^5-1)/2 mod 2^32
    58824U,                                              // (7^6-1)/2 mod 2^32
    411771U,                                             // (7^7-1)/2 mod 2^32
};
constexpr std::uint32_t AVX2_ADD_STEP {2882400U};        // (7^8-1)/2 mod 2^32
constexpr std::uint32_t AVX2_ADD_STEP_4 {927505792U};    // (7^32-1)/2 mod 2^32

void decrypt_file_data_avx2(std::span<char> data, std::uint32_t magickey) noexcept
{
    auto v_mul_table {_mm256_load_si256(reinterpret_cast<const __m256i*>(AVX2_MUL_TABLE.data()))};
    auto v_add_table {_mm256_load_si256(reinterpret_cast<const __m256i*>(AVX2_ADD_TABLE.data()))};

    // 4 路循环展开
    auto v_mul_step {_mm256_set1_epi32(AVX2_MUL_STEP)};
    auto v_add_step {_mm256_set1_epi32(AVX2_ADD_STEP)};
    auto v_mul_step_4 {_mm256_set1_epi32(AVX2_MUL_STEP_4)};
    auto v_add_step_4 {_mm256_set1_epi32(AVX2_ADD_STEP_4)};

    // 4 路独立初始 key
    auto v_key0 {_mm256_add_epi32(_mm256_mullo_epi32(_mm256_set1_epi32(magickey), v_mul_table), v_add_table)};
    auto v_key1 {_mm256_add_epi32(_mm256_mullo_epi32(v_key0, v_mul_step), v_add_step)};
    auto v_key2 {_mm256_add_epi32(_mm256_mullo_epi32(v_key1, v_mul_step), v_add_step)};
    auto v_key3 {_mm256_add_epi32(_mm256_mullo_epi32(v_key2, v_mul_step), v_add_step)};

    // 主循环：每轮处理 4 块,共 128 字节
    auto  n {data.size()};
    auto* data_p {data.data()};
    for (; data_p < (data.data() + (n & ~MOD_128_MASK)); data_p += 128)
    {
        _mm256_storeu_si256(
            reinterpret_cast<__m256i*>(data_p + 0),
            _mm256_xor_si256(_mm256_loadu_si256(reinterpret_cast<__m256i*>(data_p + 0)), v_key0)
        );
        _mm256_storeu_si256(
            reinterpret_cast<__m256i*>(data_p + 32),
            _mm256_xor_si256(_mm256_loadu_si256(reinterpret_cast<__m256i*>(data_p + 32)), v_key1)
        );
        _mm256_storeu_si256(
            reinterpret_cast<__m256i*>(data_p + 64),
            _mm256_xor_si256(_mm256_loadu_si256(reinterpret_cast<__m256i*>(data_p + 64)), v_key2)
        );
        _mm256_storeu_si256(
            reinterpret_cast<__m256i*>(data_p + 96),
            _mm256_xor_si256(_mm256_loadu_si256(reinterpret_cast<__m256i*>(data_p + 96)), v_key3)
        );
        v_key0 = _mm256_add_epi32(_mm256_mullo_epi32(v_key0, v_mul_step_4), v_add_step_4);
        v_key1 = _mm256_add_epi32(_mm256_mullo_epi32(v_key1, v_mul_step_4), v_add_step_4);
        v_key2 = _mm256_add_epi32(_mm256_mullo_epi32(v_key2, v_mul_step_4), v_add_step_4);
        v_key3 = _mm256_add_epi32(_mm256_mullo_epi32(v_key3, v_mul_step_4), v_add_step_4);
    }

    decrypt_file_data_scalar(data.subspan(data.size() - (n & MOD_128_MASK)), _mm256_cvtsi256_si32(v_key0));
}
#endif

void decrypt_file_data_dispatch(std::span<char> data, std::uint32_t magickey) noexcept
{
#ifdef __AVX512F__
    decrypt_file_data_avx512(data, magickey);
#elifdef __AVX2__
    decrypt_file_data_avx2(data, magickey);
#else
    decrypt_file_data_scalar(data, magickey);
#endif
}

void write_file(const std::filesystem::path& path, std::span<char> data)
{
    std::ofstream f {path, std::ios::binary};
    f.write(data.data(), data.size());
}

std::unique_ptr<char[]> read_file(const std::filesystem::path& path)
{
    auto          size {std::filesystem::file_size(path)};
    auto          data {std::make_unique_for_overwrite<char[]>(size)};
    std::ifstream f {path, std::ios::binary};
    f.read(data.get(), size);
    return data;
}

void r3exs_rgss3a_rvdata2_cxx(
    const std::filesystem::path& target_path, const std::filesystem::path& output_dir, bool verbose
)
{
    // 读取整个 RGSS3A 文件到内存并设置文件指针游标
    auto  rgss3a_data {read_file(target_path)};
    auto* rgss3a_p {rgss3a_data.get()};

    // 判断加密类型并计算 magickey
    auto decrypt_header {load_little_data<std::uint64_t>(rgss3a_p)};
    auto magickey {load_little_data<std::uint32_t>(rgss3a_p)};
    switch (decrypt_header)
    {
        [[likely]]
        case RGSSAD_HEADER :
            magickey = (magickey * 9) + 3;
            break;
        case FUX2PACK2_HEADER :
            // Fux2Pack2 的 magickey 就是文件头中读取的值,不需要额外计算
            break;
        default : throw RGSS3AFileError {std::format("Unknown RGSS3A file decrypted type:{}", target_path.string())};
    }

    // 记录所有的解密任务,最后统一处理
    std::vector<DecryptTask> tasks;
    tasks.reserve(1024);
    while (true)
    {
        // 读取数据段偏移量
        auto data_offset {load_little_data<std::uint32_t>(rgss3a_p) ^ magickey};
        if (data_offset == 0) [[unlikely]]
        {
            break;
        }
        // 读取数据段长度
        auto data_size {load_little_data<std::uint32_t>(rgss3a_p) ^ magickey};
        // 读取数据段 magicKey
        auto data_magickey {load_little_data<std::uint32_t>(rgss3a_p) ^ magickey};
        // 读取文件名长度
        auto filename_size {load_little_data<std::uint32_t>(rgss3a_p) ^ magickey};
        // 记录解密任务
        tasks.emplace_back(
            std::span<char> {rgss3a_p, filename_size},
            magickey,
            std::span<char> {rgss3a_data.get() + data_offset, data_size},
            data_magickey
        );
        // 移动文件指针游标到下一个文件头
        rgss3a_p += filename_size;
    }

    // 处理所有的解密任务,并记录需要创建的目录
    std::unordered_set<std::filesystem::path> dirs;
    for (auto& task : tasks)
    {
        decrypt_file_name(task.filename, task.filename_magickey);
        decrypt_file_data_dispatch(task.data, task.data_magickey);
        std::ranges::replace(task.filename, '\\', '/');    // 处理路径分隔符

        task.output_full_path = output_dir / std::string_view(task.filename);
        dirs.emplace(task.output_full_path.parent_path());
    }
    // 创建所有需要的目录
    for (const auto& dir : dirs)
    {
        std::filesystem::create_directories(dir);
    }
    // 写入文件
    auto start {std::chrono::high_resolution_clock::now()};
    for (const auto& task : tasks)
    {
        write_file(task.output_full_path, task.data);
        if (verbose) [[unlikely]]
        {
            std::println(
                GREEN_COLOR("Decrypted:") "{} " GREEN_COLOR("Size:") MAGENTA_COLOR("{}"),
                task.output_full_path.string(),
                task.data.size()
            );
        }
    }
    auto end {std::chrono::high_resolution_clock::now()};

    std::println(
        "Decryption completed in {} ms", std::chrono::duration_cast<std::chrono::milliseconds>(end - start).count()
    );
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
VALUE r3exs_rgss3a_rvdata2(VALUE self, VALUE target_path, VALUE output_dir, VALUE verbose)
{
    try
    {
        r3exs_rgss3a_rvdata2_cxx(
            std::filesystem::path(RSTRING_PTR(target_path)),
            std::filesystem::path(RSTRING_PTR(output_dir)),
            RB_TEST(verbose)
        );
    }
    catch (const RGSS3AFileError& e)
    {
        rb_exc_raise(rb_funcall(
            rb_const_get(self, rb_intern("RGSS3AFileError")),
            rb_intern("new"),
            2,
            rb_str_new_cstr(e.what()),
            target_path
        ));
    }
    catch (const std::filesystem::filesystem_error& e)
    {
        rb_syserr_fail(e.code().value(), e.what());
    }
    return Qnil;
}

}    // namespace

extern "C"
{
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
        VALUE R3EXS {rb_define_module("R3EXS")};
        // 定义 rgss3a_rvdata2 方法
        rb_define_singleton_method(R3EXS, "rgss3a_rvdata2", r3exs_rgss3a_rvdata2, 3);
    }
}
