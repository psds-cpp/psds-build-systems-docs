cmake_minimum_required(VERSION 3.16)
project(macro NONE)

set(NAME "world")

macro(say)
  message(STATUS "name: ${NAME}")
  set(LEAKED "set in macro")
endmacro()

say()
message(STATUS "LEAKED = ${LEAKED}")
