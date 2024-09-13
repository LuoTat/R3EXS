# 编译器
CC = gcc

# 编译选项
CFLAGS = -std=c23 -O3 -Wall -Wextra -Werror

# 目标文件名称
TARGET = rgss3a_rvdata2

# 源文件
SRC = rgss3a_rvdata2.c

# 目标规则：编译目标可执行文件
$(TARGET): $(SRC)
	$(CC) $(CFLAGS) -o $(TARGET) $(SRC)

# 清理生成的文件
.PHONY: clean
clean:
	rm -f $(TARGET)
