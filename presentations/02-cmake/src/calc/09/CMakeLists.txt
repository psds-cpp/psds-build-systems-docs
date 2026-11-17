cmake_minimum_required(VERSION 3.16)
project(calc C)

option(ENABLE_TRACE "Собирать libcalc с трассировкой" OFF)
set(LOG_LEVEL "INFO" CACHE STRING "Уровень логирования")

add_library(calc STATIC calc.c)
target_include_directories(calc PUBLIC .)
if(ENABLE_TRACE)
  target_compile_definitions(calc PRIVATE ENABLE_TRACE)
endif()
target_compile_definitions(calc PRIVATE LOG_LEVEL=${LOG_LEVEL})

add_executable(calc_app main.c)
target_link_libraries(calc_app PRIVATE calc)
