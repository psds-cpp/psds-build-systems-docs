# Демонстрационный toolchain: «кросс» на ту же архитектуру
# (Linux x86_64 → Linux x86_64) — доказательство механизма.
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR x86_64)

# Компилятор, который есть на этой машине, абсолютным путём
set(CMAKE_C_COMPILER /usr/bin/gcc)

# Маркер: ставится здесь, читается в CMakeLists.txt
set(TOOLCHAIN_MARKER "loaded: ${CMAKE_TOOLCHAIN_FILE}")
message(STATUS "toolchain file read (before project())")
