cmake_minimum_required(VERSION 3.16)
project(genex C)

add_executable(app app.c)

target_compile_definitions(app PRIVATE
  MODE=$<IF:$<CONFIG:Debug>,"DEBUG","RELEASE">)
