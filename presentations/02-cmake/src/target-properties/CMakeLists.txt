cmake_minimum_required(VERSION 3.16)
project(calc C)

add_library(calc)

target_compile_options(calc PRIVATE -Wall -Wextra)
target_sources(calc PRIVATE calc.c)

get_target_property(OPTS calc COMPILE_OPTIONS)
get_target_property(SRCS calc SOURCES)

message(STATUS "Options: ${OPTS}")
message(STATUS "Sources: ${SRCS}")
