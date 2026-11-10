cmake_minimum_required(VERSION 3.16)
project(vars-demo NONE)

set(WHO "directory variable") # Обычная переменная, "видна" только в CMakeLists.txt
message(STATUS "WHO   = ${WHO}")

set(WHERE "default" CACHE STRING "Where variable lives") # Кэш-переменная в CMakeCache.txt
message(STATUS "WHERE = ${WHERE}")
