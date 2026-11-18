cmake_minimum_required(VERSION 3.16)
project(calc C)

include(FetchContent)
FetchContent_Declare(
  zlib
  URL https://zlib.net/zlib-1.4.tar.gz
  DOWNLOAD_EXTRACT_TIMESTAMP TRUE
)
set(FETCHCONTENT_QUIET OFF)
set(ZLIB_BUILD_TESTING OFF)
set(ZLIB_BUILD_STATIC OFF)
FetchContent_MakeAvailable(zlib)

add_library(calc STATIC calc.c)
target_include_directories(calc PUBLIC .)

add_executable(calc_app main.c)
target_link_libraries(calc_app PRIVATE calc ZLIB::ZLIB)
