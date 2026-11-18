cmake_minimum_required(VERSION 3.16)
project(func-macro C)

function(make_lib name)
  add_library(${name} STATIC ${name}.c)
  target_compile_options(${name} PRIVATE -Wall -Wextra)
  target_include_directories(${name} PUBLIC .)
endfunction()

make_lib(math)
make_lib(geo)
make_lib(vec)
