set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR x86_64)

set(CMAKE_C_COMPILER /usr/bin/gcc)

set(TOOLCHAIN_MARKER "loaded: ${CMAKE_TOOLCHAIN_FILE}")
message(STATUS "toolchain file read (before project())")
