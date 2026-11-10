cmake_minimum_required(VERSION 3.16)
project(calc C)

set(CMAKE_C_COMPILER /usr/bin/gcc)
message(STATUS "after set(): ${CMAKE_C_COMPILER}")

add_library(calc STATIC calc.c)
target_include_directories(calc PUBLIC .)

add_executable(calc_app main.c)
target_link_libraries(calc_app PRIVATE calc)
