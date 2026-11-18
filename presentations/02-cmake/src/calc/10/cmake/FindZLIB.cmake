# Local override of the built-in FindZLIB.cmake
message(STATUS "Using local FindZLIB.cmake")
include(FindPackageHandleStandardArgs)
find_path(ZLIB_INCLUDE_DIR zlib.h)
find_library(ZLIB_LIBRARY z)
find_package_handle_standard_args(
  ZLIB
  REQUIRED_VARS ZLIB_LIBRARY ZLIB_INCLUDE_DIR
)
if(ZLIB_FOUND)
  add_library(ZLIB::ZLIB UNKNOWN IMPORTED)
  set_target_properties(ZLIB::ZLIB PROPERTIES
    IMPORTED_LOCATION "${ZLIB_LIBRARY}"
    INTERFACE_INCLUDE_DIRECTORIES "${ZLIB_INCLUDE_DIR}"
  )
endif()
