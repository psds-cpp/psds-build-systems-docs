cmake_minimum_required(VERSION 3.16)
project(calc C)

set(CMAKE_C_STANDARD 99)
set(CMAKE_C_STANDARD_REQUIRED ON)

add_library(calc STATIC calc.c)
target_include_directories(calc PUBLIC .)
target_compile_options(calc PRIVATE -Wall -Wextra)

add_executable(calc_app main.c)
target_compile_options(calc_app PRIVATE -Wall -Wextra)
target_link_libraries(calc_app PRIVATE calc)
