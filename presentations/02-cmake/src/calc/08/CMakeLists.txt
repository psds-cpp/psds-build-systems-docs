cmake_minimum_required(VERSION 3.16)
project(calc C)

add_library(calc)
target_sources(calc
    PRIVATE calc.c
    PUBLIC FILE_SET HEADERS FILES calc.h
)

target_include_directories(calc PUBLIC .)
target_compile_options(calc PRIVATE -Wall -Wextra)

install(TARGETS calc
    ARCHIVE DESTINATION lib
    FILE_SET HEADERS DESTINATION include
)
