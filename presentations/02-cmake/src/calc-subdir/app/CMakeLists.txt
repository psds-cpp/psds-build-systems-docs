add_executable(main PRIVATE main.c)
target_include_directories(main PUBLIC ../lib)
target_link_libraries(main PRIVATE calc)
