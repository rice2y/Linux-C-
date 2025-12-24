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
# 问题：
2.

