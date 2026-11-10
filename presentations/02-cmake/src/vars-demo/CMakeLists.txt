cmake_minimum_required(VERSION 3.16)
project(vars-demo NONE)

# Обычная переменная — видна только в CMakeLists.txt
set(WHO "directory variable")
message(STATUS "WHO   = ${WHO}")

# Кэш-переменная — живёт в CMakeCache.txt,
# переопределяется из командной строки флагом -D
set(WHERE "default" CACHE STRING "Where variable lives")
message(STATUS "WHERE = ${WHERE}")
