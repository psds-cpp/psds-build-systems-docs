# комментарий
project(calc C)              # имя проекта и языки
set(FLAG -O2)                # переменная
add_executable(app main.c)   # цель
message(STATUS "flag: ${FLAG}")
cmake_minimum_required(VERSION 3.16)   # обычно — первой строкой
