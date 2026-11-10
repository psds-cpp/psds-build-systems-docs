cmake_minimum_required(VERSION 3.10) # обычно первой строкой
project(calc C)                      # имя проекта и языки
set(FLAG -O2)                        # переменная
add_executable(app main.c)           # цель
message(STATUS "flag: ${FLAG}")      # диагностика
