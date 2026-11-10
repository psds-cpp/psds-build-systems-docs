add_library(calc STATIC calc.c)
target_include_directories(calc PUBLIC .)
target_compile_options(calc PRIVATE -Wall -Wextra)
