include(FindPackageHandleStandardArgs)
include("$ENV{WORKSPACE_TOP}/common/cmake/lb.cmake")

lb_local_path(PMEM-SDK_BUILD nvml pmem-sdk)

find_path(Pmem-sdk_INCLUDE_DIR
  "libpmem.h"
  PATHS "$ENV{WORKSPACE_TOP}/nvml"
  PATH_SUFFIXES "src/include"
)

find_library(Pmem-sdk_LIBRARY NAMES libpmem.a PATHS "${PMEM-SDK_BUILD}/lib")

lb_version(PMEM-SDK_VERSION nvml pmem-sdk)

find_package_handle_standard_args(Pmem-sdk DEFAULT_MSG
  Pmem-sdk_INCLUDE_DIR Pmem-sdk_LIBRARY
)

# I'm not entirely sure if it's needed, but it sounds
# like a best practice. I'm not sure I understand the documentation:
# https://cmake.org/cmake/help/v3.12/manual/cmake-developer.7.html#modules
if(Pmem-sdk_FOUND)
  set(Pmem-sdk_LIBRARIES ${Pmem-sdk_LIBRARY})
  set(Pmem-sdk_INCLUDE_DIRS ${Pmem-sdk_INCLUDE_DIR})
  message("GOT ${Pmem-sdk_INCLUDE_DIR}")
endif()

if(Pmem-sdk_FOUND AND NOT TARGET Nvml::Pmem-sdk)
  add_library(Nvml::Pmem-sdk UNKNOWN IMPORTED)
  set_target_properties(Nvml::Pmem-sdk PROPERTIES
    IMPORTED_LOCATION "${Pmem-sdk_LIBRARY}"
    INTERFACE_INCLUDE_DIRECTORIES "${Pmem-sdk_INCLUDE_DIR}"
  )
endif()
