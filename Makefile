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
CC = gcc
CFLAGS = -wall -o2
#使用变量
program:main.c
  $(CC) $(CFLAGS) -o program main.c
