一、基础概念
1.Makefile是什么？
定义：自动化构建工具，用于管理源代码编译
作用：根据文件依赖关系自动执行编译命令
核心思想：只重新编译需要更新的文件

2.基本组成
target:prerequisites
  recipe
目标（target）:要生成的文件或执行的操作
依赖（prerequisites）:生成目标所需的文件
命令(recipe):生成目标的Shell命令（前面的不是空格符，而是tab）

二、基础语法
1.第一个Makefile
hello:
  echo "hello,makefile!"
# makefile的注释是以#开头
# 运行make hello相当于在Shell命令行中输入echo "hello,makefile!"，得到hello,makefile

2.变量定义
#简单变量
CC = g++
DD = test.c
#使用变量
test:test.c
  $(CC) $(DD) -o test

3.自动变量
$@   #目标文件名
$<   #第一个依赖的文件名
$^   #所有依赖的文件
$?   #比目标文件新的依赖文件列表
$*   #匹配通配符的部分
test:test.cc
	$(CC) $? -o $@

三、核心功能
1.1通配符
# * - 匹配任意数量字符
SOURCES = *.c      #匹配所有.c文件
HEARDS = *.h       #匹配所有.h文件
# ？ - 匹配单个字符
TEST_FILES = test?.cc    #匹配test1.c,test2.c,但是不匹配test10.c
# [...] - 匹配括号内的任意字符
SPECIAL = file[123].c    #匹配file1.c,file2.c,file3.c
RANGES = chap[1-9].c     #匹配chap1.c 到 chap9.c

1.2通配符的两种使用时机
#重要区别：立即展开VS延迟展开
IMMEDIATE := *.c   #  :=代表着在赋值时立即展开，得到文件
DEFERRED = *.c     #  ：代表着在使用的时候展开，目前保持着“*.c”字符串

1.3 wildcard函数
# 问题：直接使用*.c 可能无法匹配到文件
SOURCES = *.c    #如果没有.c文件，SOURCES = "*.c"（字符串）
#解决方案
SOURCES := $(wildcard src/*.c)    #只有存在的文件才会被列出
HEADERS := $(wildcard include/*.h)

2.模式匹配的工作原理
#语法：目标模式：依赖模式
%。o:%.c
	$(CC) -c $< -o $@
#假设有main.c util.c
#make 看到%.o:%.c 时：
#1.查找所有.c文件：main.c utils.c
#2.生成目标：main.o utils.o
#3.建立依赖关系：
# main.o:main.c
# utils.o:utils.c
#4.当执行规则时，%被替换为匹配的部分

3.伪目标（Phony Targets）
#定义：伪目标不是一个实际的文件，而是一个标签或动作标识符
.PHONY: clean install   #告诉make：clean和install时伪目标（即使存在同名文件clean，也是正常执行命令）
clean:
	rm -f *.o program   #清理构建产生的文件
install:
	cp program /usr/local/bin/   #拷贝复制文件

4.函数使用
#常用函数
FILES = $(wildcard *.c)   #获取所有的.c文件
OBJS = $(patsubst %.c,%.o,$(FILES))  #将FILES中所有的.c文件后缀改为.o
DIRS = $(dir src/foo.c src/bar.c)    #获取目录 上述的例子只会输出src/

5.条件判断
ifeq ($(CC),gcc)        # 如果 CC 等于 "gcc"
    CFLAGS += -std=gnu99  # 添加 GNU C99 标准
else                     # 否则
    CFLAGS += -std=c99    # 添加 ISO C99 标准
endif                    # 结束判断

四、项目管理
1.多文件项目结构
#典型C项目Makefile示例
CC = gcc						#编译器指定为gcc
CFLAGS = -Wall -I./include		#编译选项：-Wall 显示所有警告 -I./include 指定头文件目录
LDFLAGS = -lm					#链接选项：-lm 链接数学库（math.h）

SRC_DIR  = src
OBJ_DIR  = obj
BIN_DIR  = bin

SOURCES = $(wildcard $(SRC_DIR)/*.c)    #自动获取src目录下所有.c源文件
OBJECTS = $(patsubst $(SRC_DIR)/%.c,%(OBJ_DIR)/%.o,$(SOURCES)) 		#将src/.c转换为obj/*.o（目标文件）
TARGET = $(BIN_DIR)/myapp     #最终生成的可执行文件路径

$(TARGET):$(OBJECTS)
	$(CC) %^ -o $@ $(LDFLAGS)		#核心目标：生成可执行文件（依赖所有.o文件）

$(OBJ_DIR)/%.O:$(SRC_DIR)/%.c
	$(CC) $(CFLAGS) -c $< -o $@  	#编译规则：将每个.c文件编译为.o文件（依赖对应的.c文件）

clean:
rm -f $(OBJ_DIR)/*.o $(TARGET)

