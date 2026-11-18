cmake_minimum_required(VERSION 3.16)
project(func NONE)

function(say name flags)
  set(LOCAL "local variable")
  message(STATUS "name: ${name}, flags: ${flags}, rest: ${ARGN}")
  set(SAID "said: ${name}" PARENT_SCOPE)
endfunction()

say(world -Wall -Wextra -O2)
message(STATUS "LOCAL  = ${LOCAL}")
message(STATUS "SAID   = ${SAID}")
