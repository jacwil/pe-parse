find_path(PEPARSE_INCLUDE_DIR "parser-library/parse.h")
find_library(PEPARSE_LIBRARIES NAMES "pe-parser-library")

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(peparse DEFAULT_MSG PEPARSE_INCLUDE_DIR PEPARSE_LIBRARIES)
