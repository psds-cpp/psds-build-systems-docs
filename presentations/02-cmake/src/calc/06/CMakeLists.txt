cmake_minimum_required(VERSION 3.16)
project(calc C)

message(STATUS "toolchain marker: ${TOOLCHAIN_MARKER}")
message(STATUS "CROSSCOMPILING = ${CMAKE_CROSSCOMPILING}")

add_library(calc STATIC calc.c)
target_include_directories(calc PUBLIC .)
